alias Chukinas.Geometry.{Collide, CollidableShape}
alias Collision.{Detection, Polygon}

defmodule Collide do

  def collide?(a, b) do
    Detection.SeparatingAxis.collision?(
      to_poly(a) |> IOP.inspect("square as poly"),
      to_poly(b) |> IOP.inspect("island as ploy")
    )
    |> IOP.inspect("overlaps")
  end

  def any?(a, shapes) when is_list(shapes) and not is_list(a) do
    main_polygon = Polygon.from_vertices(CollidableShape.to_vertices a)
    shapes
    |> Stream.map(&CollidableShape.to_vertices/1)
    |> Stream.map(&Polygon.from_vertices/1)
    |> Enum.any?(fn polygon ->
      IOP.inspect(polygon, "island")
      Detection.SeparatingAxis.collision?(main_polygon, polygon)
      |> IOP.inspect("collides with island?")
    end)
  end

  def none?(a, shapes) when is_list(shapes) and not is_list(a) do
    not any?(a, shapes) |> IOP.inspect("doesn't overlap island")
  end

  # *** *******************************
  # *** PRIVATE

  defp to_poly(shape) do
    shape
    |> CollidableShape.to_vertices
    |> Polygon.from_vertices
  end

end
