defmodule Dreadnought.Core.Island do
  @moduledoc"""
  Handles rendering and collision of islands for ships and players to interact with
  """

    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Island
  alias Dreadnought.LinearAlgebra.Vector

  # *** *******************************
  # *** TYPES

  typedstruct do
    field :id, integer
    # TODO rename position_points ?
    field :relative_vertices, list(POS.position_struct)
    position_fields()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(id, location, points) do
    fields =
      %{
        id: id,
        relative_vertices: points
      }
      |> merge_position(location)
    struct!(__MODULE__, fields)
  end

  def random(id, location) when has_position(location) do
    radius = 250
    sides = 7
    angle = 360 / sides
    points =
      0..(sides - 1)
      |> Stream.map(fn i ->
        (i * angle)
        |> Vector.from_angle
        |> Vector.scalar(radius)
        |> position_new
        |> position_shake
      end)
      |> Enum.to_list
    new(id, location, points)
  end

  # *** *******************************
  # *** CONVERTERS

  def position_points(%__MODULE__{relative_vertices: val}), do: val

  def world_coord(island, relative_position) do
    island
    |> position_new
    |> position_add(relative_position)
    |> vector_from_position
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Dreadnought.Core.Island

defimpl Dreadnought.Collide.IsShape, for: Island do
  def to_coords(island) do
    island
    |> Island.position_points
    |> Enum.map(&Island.world_coord(island, &1))
  end
end

