# TODO refactor aliases
alias Chukinas.Collide
alias Collision.Polygon.Vertex
alias Chukinas.Collide.Shape
alias Chukinas.Collide.Collide, as: Coll

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
    Shape.from_coords(coords)
  end

  # *** *******************************
  # *** COLLISION DETECTION

  def avoids_collision_with?(element, obstacles) do
    Coll.avoids?(element, obstacles)
  end

  # TODO refactor away the need for this function
  defdelegate generate_include_filter(item), to: Coll

end
