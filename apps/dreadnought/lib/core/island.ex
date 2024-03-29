defmodule Dreadnought.Core.Island do
  @moduledoc"""
  Handles rendering and collision of islands for ships and players to interact with
  """

  use Spatial.LinearAlgebra
  use Spatial.PositionOrientationSize
  use Spatial.TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct do
    # TODO remove id
    field :id, integer
    field :relative_points, [position]
    pose_fields()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(id, pose, relative_points)
  when is_integer(id)
  and has_pose(pose)
  and is_list(relative_points) do
    fields =
      %{
        id: id,
        relative_points: relative_points
      }
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
  end

  def new(id, position, relative_points) when has_position(position) do
    pose = pose_from_position(position, 0)
    new(id, pose, relative_points)
  end

  # TODO replace random with calls to Island.BUilder
  def random(id, position) do
    radius = 250
    sides = 7
    angle = 360 / sides
    relative_points =
      0..(sides - 1)
      |> Stream.map(fn i ->
        (i * angle)
        |> vector_from_angle
        |> vector_multiply(radius)
        |> position_new
        |> position_shake
      end)
      |> Enum.to_list
    new(id, position, relative_points)
  end

  # *** *******************************
  # *** CONVERTERS

  def relative_points(%__MODULE__{relative_points: val}), do: val

  def absolute_points(island) do
    island
    |> relative_points
    |> Enum.map(&position_add(&1, island))
  end

  def absolute_coords(island) do
    island
    |> absolute_points
    |> Enum.map(&position_to_tuple/1)
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Dreadnought.Core.Island

defimpl Spatial.Collide.IsShape, for: Island do
  def to_coords(island), do: Island.absolute_coords(island)
end

