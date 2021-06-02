alias Chukinas.Geometry.{Collide, CollidableShape}
alias Collision.{Detection, Polygon}

defmodule Collide do

  def collide?(a, b) do
    Detection.SeparatingAxis.collision?(
      polygon_from_shape(a),
      polygon_from_shape(b)
    )
  end

  def any?(a, shapes) when is_list(shapes) and not is_list(a) do
    subject = polygon_from_shape(a)
    obstacles =
      for shape <- shapes, do: polygon_from_shape(shape)
    Enum.any?(obstacles, fn obstacle ->
      Detection.SeparatingAxis.collision?(subject, obstacle)
    end)
  end

  def avoids?(a, shapes) when is_list(shapes) and not is_list(a) do
    not any?(a, shapes)
  end

  def generate_include_filter(target) do
    target_polygon =
      polygon_from_shape(target)
    fn shape ->
      shape
      |> polygon_from_shape
      |> Detection.SeparatingAxis.collision?(target_polygon)
    end
  end

  # *** *******************************
  # *** CONVERSIONS

  defp polygon_from_shape(shape) do
    shape
    |> CollidableShape.to_coords
    |> vertices_from_coords
  end

  def vertices_from_coords(coords) do
    for coord <- coords, do: vertex_from_coord(coord)
  end

  def vertex_from_coord(coord) do
    Polygon.Vertex.from_tuple(coord)
  end

end
