alias Chukinas.Geometry.{Polygon, Position}

defmodule Polygon do
  @moduledoc"""
  An arbitrary 2D shape composed of straight edges
  """

  use TypedStruct

  typedstruct enforce: true do
    # TODO I should use Collision.Polygon.Vertex instead?
    field :vertices, [Position.t()]
  end

  # *** *******************************
  # *** NEW

  def new(vertices) when length(vertices) > 2 do
    %__MODULE__{
      vertices: vertices |> Enum.map(&Position.new/1)
    }
  end

  # TODO this should be a protocol implementation
  def to_vertices(polygon) do
    polygon.vertices
    |> Enum.map(&Position.to_vertex/1)
  end

end
