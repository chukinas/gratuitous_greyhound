alias Dreadnought.Collide.{CollisionDetection, IsShape}
alias Collision.{Detection, Polygon}

defmodule CollisionDetection do

  def collide?(a, b) do
    Detection.SeparatingAxis.collision?(
      polygon_from_shape(a),
      polygon_from_shape(b)
    )
  end

  def any?(subject, obstacles)
  when not is_list(subject)
  and      is_list(obstacles) do
    subject = polygon_from_shape(subject)
    obstacles =
      for shape <- obstacles, do: polygon_from_shape(shape)
    Enum.any?(obstacles, fn obstacle ->
      Detection.SeparatingAxis.collision?(subject, obstacle)
    end)
  end

  def avoids?(subject, obstacles)
  when not is_list(subject)
  and      is_list(obstacles) do
    not any?(subject, obstacles)
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
    |> IsShape.to_coords
    |> vertices_from_coords
    |> Polygon.from_vertices
  end

  def vertices_from_coords(coords) do
    for coord <- coords, do: vertex_from_coord(coord)
  end

  def vertex_from_coord(coord) do
    Polygon.Vertex.from_tuple(coord)
  end

end
