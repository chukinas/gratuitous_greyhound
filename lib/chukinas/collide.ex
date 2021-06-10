alias Chukinas.Collide
alias Chukinas.Collide.{CollisionDetection, Shape}

defmodule Collide do

  use Chukinas.LinearAlgebra

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
