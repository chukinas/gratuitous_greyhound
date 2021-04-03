alias Chukinas.Geometry.{Position, CollidableShape, Pose}

defmodule Chukinas.Dreadnought.Island do
  @moduledoc"""
  Handles rendering and collision of islands for ships and players to interact with
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    # ID must be unique within the world
    field :id, integer()
    field :relative_vertices, [Position.t()]
    field :position, Position.t()
  end

  # *** *******************************
  # *** NEW

  def new(id, position, points) do
    %__MODULE__{
      id: id,
      relative_vertices: points,
      position: position
    }
  end

  # *** *******************************
  # *** RANDOMIZER

  def random(id) do
    radius = 250
    sides = 7
    angle = 360 / sides
    points =
      0..(sides - 1)
      |> Stream.map(fn i ->
        Pose.origin()
        |> Pose.rotate(i * angle)
        |> Pose.straight(radius)
        |> Position.shake
      end)
      |> remove_inner_points
      |> Enum.to_list
    new(id, Position.new(500, 500), points)
  end

  def remove_inner_points(points) do
    # TODO implement
    points
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(island) do
      island.relative_vertices
      |> Stream.map(&Position.add(&1, island.position))
      |> Enum.map(&Position.to_vertex/1)
    end
  end
end
