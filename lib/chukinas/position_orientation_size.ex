alias Chukinas.Geometry.{Size, Position, Pose}
alias Chukinas.PositionOrientationSize, as: POS

defmodule POS do

  require Position.Guard
  import Position.Guard

  defmacro __using__(_opts) do
    quote do
      require Position.Guard
      import Position.Guard
      require POS
      import POS
      alias POS, as: POS
      use Chukinas.TypedStruct
    end
  end

  # *** *******************************
  # *** STRUCT HELPERS

  @type position_key    :: :x | :y
  @type pose_key        :: :angle | position_key
  @type size_key        :: :width | :height

  @type position_map    :: %{position_key => number, optional(any) => any}
  @type pose_map        :: %{pose_key     => number, optional(any) => any}
  @type size_map        :: %{size_key     => number, optional(any) => any}
  @type pos_map         :: position_map | pose_map | size_map

  @type position_struct :: Position.t
  @type pose_struct     :: Pose.t
  @type size_struct     :: Size.t
  @type pos_struct      :: Position.t | Pose.t | Size.t

  @type pos_type        :: :position | :pose | :size
  #@type position_tuple  :: {:position,  position_map}
  #@type pose_tuple      :: {:pose,      pose_map}
  #@type size_tuple      :: {:size,      size_map}
  #@type pos_tuple       :: position_tuple | pose_tuple | size_tuple
  @type pos_tuple       :: {pos_type, pos_map}
  @type pos_keywords    :: [pos_tuple]

  # TODO rename ? pose_into_new_struct
  #@spec pos_into_struct(pos_keywords, module, [{atom, any}]) :: struct
  #def pos_into_struct(pos, module, fields) when is_list(pos) and is_atom(module) and is_list(fields) do
  #  struct!(module, pos_into(pos, fields))
  #end

  #defp pos_into(pos, fields) when is_list(pos) and is_list(fields) do
  #  Enum.reduce(pos, fields, &pos_into/2)
  #end

  #defp pos_into({type, value}, enum), do: pos_into(type, value, enum)

  #defp pos_into(type, value, struct) when is_struct(struct) do
  #  value
  #  |> to_list(type)
  #  |> Enum.reduce(struct, fn {key, value}, struct ->
  #    Map.put(struct, key, value)
  #  end)
  #end

  #defp pos_into(type, value, enum) do
  #  value
  #  |> to_list(type)
  #  |> Enum.into(enum)
  #end

  #defp to_list(%{} = pos_map, type) do
  #  pos_map
  #  |> Map.take(keys(type))
  #  |> Enum.to_list
  #end

  #defp keys(:position), do: ~w(x y)a
  #defp keys(:pose), do: ~w(x y angle)a
  #defp keys(:size), do: ~w(width height)a

  # TODO see note for pose_into
  #def position_into(position, enum \\ []) do
  #    position
  #    |> Map.take(~w(x y)a)
  #    |> Enum.into(enum)
  #end

  ## TODO see note for pose_into
  #def size_into(position, enum \\ []) do
  #    position
  #    |> Map.take(~w(width height)a)
  #    |> Enum.into(enum)
  #end

  # TODO there should maybe be a pose_into and pose_into! or pose_into_new! ...?
  #def pose_into!(pose, poseable_item)
  #when has_pose(pose)
  #and has_pose(poseable_item) do
  #  pos_into(:pose, pose, poseable_item)
  #  # TODO remove this from pose?:
  #  # Pose.put_pose(poseable_item, pose)
  #end

  #def pose_to_keywords(pose) do
  #  pose
  #  |> pose()
  #  |> Map.from_struct
  #  |> Enum.into([])
  #end

  # *** *******************************
  # *** MERGE

  #def pos_merge(list, pos) when is_struct(pos)
  #  pos
  #  |> build_pos_struct.()
  #  |>
  #  |> Enum.into(list)
  #end

  #def pos_merge(list, pos) when length(list) > 0 do
  #  pos
  #  |> build_pos_struct.()
  #  |>
  #  |> Enum.into(list)
  #end

  #def pos_merge(enum, pos, type) when length(enum) > 0 do
  #  pos
  #  |> new_func(type).()
  #  |> Enum.into(enum)
  #end

  #defp pos_any_to_map(pos_keyword) when is_list(pos_keyword) do

  #end

  def pos_into!(pos_struct, %{} = map) do
    # TODO replace with protocol
    case pos_struct do
      %Pose{} -> pos_struct
    end
    |> Map.from_struct
    |> Enum.into([])
    |> Enum.reduce(map, fn {key, value}, map ->
      Map.replace!(map, key, value)
    end)
  end

  @spec pos_map_to(pos_map, pos_type, :keyword) :: keyword
  def pos_map_to(pos_map, type, :keyword) do
    pos_map
    |> pos_map_to(type, :map)
    |> Enum.into([])
  end

  @spec pos_map_to(pos_map, pos_type, :map) :: pos_map
  def pos_map_to(pos_map, type, :map) do
    pos_map
    |> pos_map_to(type, :struct)
    |> Map.from_struct
  end

  @spec pos_map_to(pos_map, pos_type, :struct) :: struct
  def pos_map_to(pos_map, type, :struct) do
    new =
      case type do
        :position -> &position_new/1
        :pose     -> &pose_new/1
        :size     -> &size_new/1
      end
    new.(pos_map)
  end

  # *** *******************************
  # *** POSITION

  @type position_type :: Position.t()
  @type position_list :: [position_type]

  @spec position_new(any) :: Position.t
  defdelegate position_new(term), to: Position, as: :new
  @spec position_new(any, any) :: Position.t
  defdelegate position_new(a, b), to: Position, as: :new

  defdelegate position(term), to: Position, as: :new
  defdelegate position(a, b), to: Position, as: :new

  defdelegate position_from_size(size), to: Position, as: :from_size

  # TODO this doesn't belong here
  defdelegate position_to_vertex(position), to: Position, as: :to_vertex

  defdelegate position_to_tuple(position), to: Position, as: :to_tuple

  defdelegate position_add(has_position, term), to: Position, as: :add
  defdelegate position_add_x(has_position, scalar), to: Position, as: :add_x
  defdelegate position_add_y(has_position, scalar), to: Position, as: :add_y

  defdelegate position_subtract(position, scalar), to: Position, as: :subtract

  defdelegate position_multiply(position, scalar), to: Position, as: :multiply

  defdelegate position_divide(position, scalar), to: Position, as: :divide

  defdelegate position_min_max(items_with_position), to: Position, as: :min_max

  defdelegate position_shake(position), to: Position, as: :shake

  # *** *******************************
  # *** SIZE

  def size_new(a, b) when has_position(a) and has_position(b) do
    Size.new(a, b)
  end
  defdelegate size_new(size), to: Size, as: :new
  defdelegate size_new(a, b), to: Size, as: :new

  defdelegate size_multiply(size, scalar), to: Size, as: :multiply

  defdelegate width(size), to: Size

  defdelegate height(size), to: Size

  # *** *******************************
  # *** ORIENTATION

  # TODO rename orientation
  def angle(%{angle: value}), do: value

  # TODO rename rotate?
  defdelegate orientation_rotate(orientation, angle), to: Pose, as: :rotate

  # *** *******************************
  # *** POSE

  defdelegate pose_new(term), to: Pose, as: :new
  defdelegate pose_new(position, angle), to: Pose, as: :new
  defdelegate pose_new(x, y, angle), to: Pose, as: :new

  # TODO remove?
  defdelegate pose(term), to: Pose, as: :new
  defdelegate pose(x, y, angle), to: Pose, as: :new

  defdelegate pose_origin(), to: Pose, as: :origin

  # TODO there should be a better API
  def opts_convert_pose(opts) do
    case Keyword.pop(opts, :pose) do
      {nil, _} ->
        opts
      {pose, opts} ->
        pose_keywords = pos_map_to(pose, :pose, :keyword)
        Keyword.merge(opts, pose_keywords)
    end
  end

end
