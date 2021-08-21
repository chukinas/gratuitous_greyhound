defmodule Dreadnought.PositionOrientationSize do

  use Dreadnought.Math
  use Dreadnought.PositionOrientationSize.Types
  require Dreadnought.PositionOrientationSize.Guards
  import Dreadnought.PositionOrientationSize.Guards
  alias Dreadnought.Math
  alias Dreadnought.PositionOrientationSize.IsPos
  alias Dreadnought.PositionOrientationSize.Pose
  alias Dreadnought.PositionOrientationSize.PoseApi
  alias Dreadnought.PositionOrientationSize.Position
  alias Dreadnought.PositionOrientationSize.Size
  alias Dreadnought.Util.Maps
  alias Dreadnought.Util.Precision

  defmacro __using__(_opts) do
    alias Dreadnought.PositionOrientationSize, as: POS
    quote do
      use POS.Types
      require POS.Guards
      require POS
      import POS
      alias POS, as: POS
      # TODO remove this
      use Dreadnought.TypedStruct
      import POS.AngleApi
      import POS.Guards
      import POS.PoseApi
      import POS.PositionApi

      @type position :: Position.t
    end
  end

  # *** *******************************
  # *** PRECISION

  def position_set_precision(position, precision) do
    position
    |> position_new
    |> pos_set_precision(precision)
  end

  def pose_set_precision(pose, precision) do
    pose
    |> PoseApi.pose_from_map
    |> pos_set_precision(precision)
  end

  defp pos_set_precision(struct, precision) when is_number(precision) do
    Enum.reduce(IsPos.keys(struct), struct, fn key, struct ->
      Map.update!(struct, key, &Float.round(&1 * 1.0, precision))
    end)
  end

  def position_new_rounded(map), do: Position.rounded(map)

  # *** *******************************
  # *** UPDATE

  def update_position!(item_with_position, fun) do
    position = fun.(item_with_position)
    replace_position!(item_with_position, position)
  end

  def replace_position!(item_with_position, new_position) do
    Maps.replace_keys(item_with_position, new_position, ~w/x y/a)
  end

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

  def into_struct!(fields, module), do: struct!(module, fields)

  # *** *******************************
  # *** IsPos

  def approx_equal(a, b) do
    a
    |> IsPos.keys
    |> Enum.all?(& Precision.approx_equal(a, b, &1))
  end

  # *** *******************************
  # *** POSITION

  @type position_type :: Position.t()
  @type position_list :: [position_type]

  def position_null(), do: position 0, 0

  @spec position_new(any) :: Position.t
  defdelegate position_new(term), to: Position, as: :new
  @spec position_new(any, any) :: Position.t
  defdelegate position_new(a, b), to: Position, as: :new

  defdelegate position(term), to: Position, as: :new
  defdelegate position(a, b), to: Position, as: :new

  # TODO superseded by LinearAlgebra
  def position_from_vector(vector), do: Position.new(vector)
  defdelegate position_from_size(size), to: Position, as: :from_size

  # TODO this doesn't belong here
  defdelegate position_to_vertex(position), to: Position, as: :to_vertex

  defdelegate position_to_tuple(position), to: Position, as: :to_tuple

  defdelegate position_add(has_position, term), to: Position, as: :add
  defdelegate position_add_x(has_position, scalar), to: Position, as: :add_x
  defdelegate position_add_y(has_position, scalar), to: Position, as: :add_y

  defdelegate position_subtract(position, scalar), to: Position, as: :subtract

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

  def size_add(a, b), do: Size.add(a, b)

  defdelegate size_from_position(position), to: Size, as: :from_position

  defdelegate size_from_positions(a, b), to: Size, as: :from_positions

  def size_from_square(side_len) when is_number(side_len) do
    size_new(side_len, side_len)
  end

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
    Map.update!(map, :angle, &Math.flip_sign/1)
  end

  # TODO rename rotate?
  defdelegate orientation_rotate(orientation, angle), to: Pose, as: :rotate

  def angle_from_sum(%{angle: a}, %{angle: b}), do: a + b

end
