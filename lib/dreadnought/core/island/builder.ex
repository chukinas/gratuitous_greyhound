defmodule Dreadnought.Core.Island.Builder do

  use Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Island

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

  def points(:square), do: @square_points


end
