defmodule CollisionDetection.Wrapper.Polygon do
  @moduledoc"""
  Wrapper around Collision.Polygon
  """

  use Spatial.LinearAlgebra
  alias Collision.Polygon, as: WrappedPolygon
  alias CollisionDetection.Wrapper.Vertex

  # *** *******************************
  # *** TYPES

  @type t :: WrappedPolygon.t

  # *** *******************************
  # *** CONSTRUCTORS

  def from_coords(coords) do
    coords
    |> Enum.map(&Vertex.from_coord/1)
    |> WrappedPolygon.from_vertices
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

end
