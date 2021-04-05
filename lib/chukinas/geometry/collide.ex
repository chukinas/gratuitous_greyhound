alias Chukinas.Geometry.{Collide, CollidableShape}
alias Collision.{Detection, Polygon}

defmodule Collide do

  def collide?(a, b) do
    Detection.SeparatingAxis.collision?(
      to_poly(a),
      to_poly(b)
    )
  end

  def any?(a, shapes) when is_list(shapes) and not is_list(a) do
    main_polygon = Polygon.from_vertices(CollidableShape.to_vertices a)
    shapes
    |> Stream.map(&CollidableShape.to_vertices/1)
    |> Stream.map(&Polygon.from_vertices/1)
    |> Enum.any?(fn polygon ->
      Detection.SeparatingAxis.collision?(main_polygon, polygon)
    end)
  end

  def avoids?(a, shapes) when is_list(shapes) and not is_list(a) do
    not any?(a, shapes)
  end

  def generate_include_filter(target) do
    target_polygon =
      to_poly(target)
      |> IOP.inspect("This is the command zone")
    fn shape ->
      IOP.inspect target_polygon.vertices, "target vertices"
      shape
      |> to_poly
      |> IOP.inspect("This object...")
      |> Detection.SeparatingAxis.collision?(target_polygon)
      |> IOP.inspect("collided?")
    end
  end

  defp to_poly(shape) do
    shape
    |> CollidableShape.to_vertices
    |> Polygon.from_vertices
  end

end
