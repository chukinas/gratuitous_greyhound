alias Chukinas.Collide
alias Collision.Polygon.Vertex
alias Chukinas.Geometry.Polygon
alias Chukinas.Geometry.Collide, as: Coll

defmodule Collide do

  use Chukinas.LinearAlgebra

  # *** *******************************
  # *** VERTEX

  def vertex_new(coord) when is_coord(coord) do
    Vertex.from_tuple(coord)
  end

  # *** *******************************
  # *** POLYGON

  def polygon_from_coords(coords) when is_list(coords) do
    Polygon.new(coords)
  end

  # *** *******************************
  # *** COLLISION DETECTION

  def avoids_collision_with?(element, obstacles) do
    Coll.avoids?(element, obstacles)
  end

end
