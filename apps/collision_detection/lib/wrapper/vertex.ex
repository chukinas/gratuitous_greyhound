defmodule CollisionDetection.Wrapper.Vertex do
  @moduledoc"""
  Wrapper around Collision.Polygon.Vertex
  """

  use Spatial.LinearAlgebra
  alias Collision.Polygon.Vertex

  # *** *******************************
  # *** TYPES

  @type t :: Vertex.t

  # *** *******************************
  # *** CONSTRUCTORS

  def from_coord(coord) when is_vector(coord) do
    Vertex.from_tuple(coord)
  end

  # *** *******************************
  # *** CONVERTERS

  defdelegate to_coord(vertex), to: Vertex, as: :to_tuple

end
