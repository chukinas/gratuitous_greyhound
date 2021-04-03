alias Chukinas.Geometry.{Position, CollidableShape}

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
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(island) do
      island.relative_vertices
      |> Stream.map(&Position.add(&1, island.position))
      |> Enum.map(&Position.to_vertex/1)
    end
  end
end
