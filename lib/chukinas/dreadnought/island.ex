alias Chukinas.Geometry.Position

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

  def new(id) do
    %__MODULE__{
      id: id,
      relative_vertices: [
        Position.new( 100,  100),
        Position.new(-100, -100),
        Position.new( 100, -100),
      ],
      position: Position.new(500, 500)
    }
  end
end
