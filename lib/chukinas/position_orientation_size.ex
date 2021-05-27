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
      use Chukinas.TypedStruct
    end
  end

  # *** *******************************
  # *** STRUCT HELPERS

  # TODO rename ? pose_into_new_struct
  def pos_into_struct(pos, module, fields) do
    struct!(module, pos_into(pos, fields))
  end

  def pos_into(pos, fields) when is_list(pos) do
    Enum.reduce(pos, fields, &pos_into/2)
  end

  def pos_into({type, value}, enum), do: pos_into(type, value, enum)

  def pos_into(type, value, struct) when is_struct(struct) do
    value
    |> to_list(type)
    |> Enum.reduce(struct, fn {key, value}, struct ->
      Map.put(struct, key, value)
    end)
  end

  def pos_into(type, value, enum) do
    value
    |> to_list(type)
    |> Enum.into(enum)
  end

  defp to_list(%{} = pos_map, type) do
    pos_map
    |> Map.take(keys(type))
    |> Enum.to_list
  end

  defp keys(:position), do: ~w(x y)a
  defp keys(:pose), do: ~w(x y angle)a
  defp keys(:size), do: ~w(width height)a

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
  def pose_into!(pose, poseable_item)
  when has_pose(pose)
  and has_pose(poseable_item) do
    pos_into(:pose, pose, poseable_item)
    # TODO remove this from pose?:
    # Pose.put_pose(poseable_item, pose)
  end

  def pose_to_keywords(pose) do
    pose
    |> pose()
    |> Map.from_struct
    |> Enum.into([])
  end

  # *** *******************************
  # *** POSITION

  @type position_type :: Position.t()
  @type position_list :: [position_type]

  defdelegate position_new(term), to: Position, as: :new
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
        opts
        |> Keyword.merge(pose |> pose_to_keywords)
    end
  end

end
