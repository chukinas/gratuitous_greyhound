ExUnit.start()

defmodule LinearAlgebraTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers
  alias Chukinas.LinearAlgebra.{Transform, Vector, Matrix, Token}

  test "get world origin wrt unit" do
    origin_wrt_unit =
      Pose.new(1, 1, 90)
      |> Transform.new
      |> Transform.flip
      |> IOP.inspect
      |> Transform.position
    assert origin_wrt_unit == {-1, 1}
  end

  test "convex polygons" do
    points = [
      Position.new(0, 0),
      Position.new(1, 0),
      Position.new(1, 1),
    ]
    convex_polygon =
      points
      |> Enum.map(&Position.to_vertex/1)
      |> Collision.Polygon.from_vertices
    assert convex_polygon.convex
    concave_polygon =
      points
      |> Enum.reverse
      |> Enum.map(&Position.to_vertex/1)
      |> Collision.Polygon.from_vertices
    refute concave_polygon.convex
  end
end
