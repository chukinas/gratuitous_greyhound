alias Chukinas.Geometry.CollidableShape
alias Chukinas.LinearAlgebra.Vector

defmodule Chukinas.Dreadnought.Island do
  @moduledoc"""
  Handles rendering and collision of islands for ships and players to interact with
  """

  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** TYPES

  typedstruct do
    # ID must be unique within the world
    field :id, integer()
    field :relative_vertices, list(POS.position_struct)
    position_fields()
  end

  # *** *******************************
  # *** NEW

  def new(id, location, points) do
    fields =
      %{
        id: id,
        relative_vertices: points
      }
      |> merge_position(location)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** RANDOMIZER

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
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(island) do
      island.relative_vertices
      |> Stream.map(&position_add(&1, island))
      |> Enum.map(&position_to_vertex/1)
    end
  end
end
