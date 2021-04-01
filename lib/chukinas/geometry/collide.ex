alias Chukinas.Geometry.{GridSquare, Collide, Polygon}

defmodule Collide do

  def collide?(polygon, square) do
    Collision.Detection.SeparatingAxis.collision?(
      Collision.Polygon.from_vertices(Polygon.to_vertices polygon),
      Collision.Polygon.from_vertices(GridSquare.to_vertices square)
    )
  end

end
