defmodule Dreadnought.Core.Island.Builder do

    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Island
  alias Dreadnought.Svg

  @default_size 300

  @square_points [
    {0,             0},
    {@default_size, 0},
    {@default_size, @default_size},
    {0,             @default_size}
  ]
  |> Enum.map(&vector_subtract(&1, @default_size/2))
  |> Enum.map(&vector_to_position/1)

  def build(:square, pose) when has_pose(pose) do
    Island.new(-1, pose, @square_points)
  end

  def points(:square = _shape), do: @square_points

  def svg_polygon_points_string(shape) do
    shape
    |> points
    # TODO deprecate position_to_tuple in favor of vector_from_position
    |> Enum.map(&position_to_tuple/1)
    |> Svg.polygon_points_string_from_coords
  end


end
