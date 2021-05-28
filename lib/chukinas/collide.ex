alias Chukinas.Collide
alias Collision.Polygon.Vertex

defmodule Collide do

  #use Chukinas.PositionOrientationSize

  def vertex_new({_x, _y} = position_tuple), do: Vertex.from_tuple(position_tuple)

end
