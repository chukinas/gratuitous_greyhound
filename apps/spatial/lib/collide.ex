defmodule Spatial.Collide do

  use Spatial.LinearAlgebra
  alias Spatial.Collide.CollisionDetection
  alias Spatial.Collide.Shape

  # *** *******************************
  # *** SHAPE

  def shape_from_coords(coords) when is_list(coords) do
    Shape.from_coords(coords)
  end

  # *** *******************************
  # *** COLLISION DETECTION

  def avoids_collision_with?(element, obstacles) do
    CollisionDetection.avoids?(element, obstacles)
  end

  # TODO refactor away the need for this function
  defdelegate generate_include_filter(item), to: CollisionDetection

end
