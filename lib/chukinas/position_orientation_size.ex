alias Chukinas.PositionOrientationSize, as: POS
alias POS.{Size, Position, Pose}
alias Chukinas.Util.{Maps, Precision}
alias Chukinas.Math, as: M

defmodule POS do

  require POS.Guards
  import POS.Guards
  use Chukinas.Math

  defmacro __using__(_opts) do
    quote do
      require POS.Guards
      import POS.Guards
      require POS
      import POS
      alias POS, as: POS
      use Chukinas.TypedStruct
    end
  end

  # *** *******************************
  # *** TYPES

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

  # *** *******************************
  # *** PRECISION

  def position_set_precision(position, precision) do
    position
    |> position_new
    |> pos_set_precision(precision)
  end

  def pose_set_precision(pose, precision) do
    pose
    |> pose_new
    |> pos_set_precision(precision)
  end

  defp pos_set_precision(struct, precision) when is_number(precision) do
    Enum.reduce(POS.IsPos.keys(struct), struct, fn key, struct ->
      Map.update!(struct, key, &Float.round(&1 * 1.0, precision))
    end)
  end

  def position_new_rounded(map), do: Position.rounded(map)

  # *** *******************************
  # *** MERGE

  def merge_position(map, pos_map), do: Maps.merge(map, pos_map, Position)
  def merge_pose(map, pos_map), do: Maps.merge(map, pos_map, Pose)
  def merge_size(map, pos_map), do: Maps.merge(map, pos_map, Size)

  def merge_position!(struct, pos_map), do: Maps.merge!(struct, pos_map, Position)
  def merge_pose!(struct, pos_map), do: Maps.merge!(struct, pos_map, Pose)
  def merge_size!(struct, pos_map), do: Maps.merge!(struct, pos_map, Size)

  def merge_position_into!(pos_map, struct), do: merge_position!(struct, pos_map)
  def merge_pose_into!(pos_map, struct), do: merge_pose!(struct, pos_map)
  def merge_size_into!(pos_map, struct), do: merge_size!(struct, pos_map)

  def put_angle!(struct, angle), do: %{struct | angle: angle}
  def put_angle(map, angle), do: Map.put(map, :angle, angle)

  def into_struct!(fields, module), do: struct!(module, fields)

  # *** *******************************
  # *** IsPos

  def approx_equal(a, b) do
    a
    |> POS.IsPos.keys
    |> Enum.all?(& Precision.approx_equal(a, b, &1))
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

  def position_from_vector(vector), do: Position.new(vector)
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

  def position_min_max(a, b), do: position_min_max([a, b])
  defdelegate position_min_max(items_with_position), to: Position, as: :min_max

  defdelegate position_shake(position), to: Position, as: :shake

  def put_zero_position(item) do
    Map.merge(item, %{x: 0, y: 0})
  end

  # *** *******************************
  # *** SIZE

  def size_new(a, b) when has_position(a) and has_position(b) do
    Size.new(a, b)
  end

  defdelegate size_new(size), to: Size, as: :new
  defdelegate size_new(a, b), to: Size, as: :new

  defdelegate size_from_position(position), to: Size, as: :from_position

  defdelegate size_from_positions(a, b), to: Size, as: :from_positions

  defdelegate size_multiply(size, scalar), to: Size, as: :multiply

  defdelegate width(size), to: Size

  defdelegate height(size), to: Size

  # *** *******************************
  # *** ORIENTATION

  # TODO rename orientation
  def angle(%{angle: value}), do: value
  def get_angle(%{angle: value}), do: value

  def angle_normalize(%{angle: _value} = map) do
    Map.update!(map, :angle, &normalize_angle/1)
  end

  defdelegate flip_angle(orientation), to: Pose, as: :flip

  def angle_add(map, value) do
    Map.update!(map, :angle, & &1 + value)
  end

  def angle_subtract(map, value), do: angle_add(map, -value)

  def angle_multiply(map, value) do
    Map.update!(map, :angle, & &1 * value)
  end

  def angle_flip_sign(map) do
    Map.update!(map, :angle, &M.flip_sign/1)
  end

  # TODO rename rotate?
  defdelegate orientation_rotate(orientation, angle), to: Pose, as: :rotate

  def angle_from_sum(%{angle: a}, %{angle: b}), do: a + b

  # *** *******************************
  # *** POSE

  # TODO is this redundant?
  def pose_new({x, y}, angle), do: Pose.new(x, y, angle)
  defdelegate pose_new(term), to: Pose, as: :new
  defdelegate pose_new(position, angle), to: Pose, as: :new
  defdelegate pose_new(x, y, angle), to: Pose, as: :new

  def pose(item) do
    IO.warn "DEPRECATED: PositionOrientationSize.pose/1"
    Pose.new(item)
  end

  defdelegate pose(x, y, angle), to: Pose, as: :new

  defdelegate pose_origin(), to: Pose, as: :origin

end
