alias Chukinas.Geometry.{Polygon, CollidableShape}

defmodule Polygon do
  @moduledoc"""
  An arbitrary 2D shape composed of straight edges
  """

  use Chukinas.PositionOrientationSize

  typedstruct enforce: true do
    # TODO I should use Collision.Polygon.Vertex instead?
    field :vertices, POS.position_list
  end

  # *** *******************************
  # *** NEW

  def new(vertices) when length(vertices) > 2 do
    %__MODULE__{
      vertices: vertices |> Enum.map(&position/1)
    }
  end

  # TODO this should be a protocol implementation
  def to_vertices(polygon) do
    polygon.vertices
    |> Enum.map(&position_to_vertex/1)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(polygon), do: Polygon.to_vertices(polygon)
  end

end
