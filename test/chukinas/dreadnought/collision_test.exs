ExUnit.start()

defmodule CollisionTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "get squares which include a target shape" do
    [
      {Rect.new(10, 10, 90, 90), 1},
      {Rect.new(10, 10, 90, 190), 2},
      {Rect.new(10, 110, 90, 190), 1},
      {Rect.new(150, 50, 200, 200), 0}
    ]
    |> Enum.each(fn {target, expected_count} ->
      assert expected_count == Grid.new(100, 1, 2)
        |> Grid.squares(include: target, threshold: 1)
        |> Enum.count
    end)
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
      ##|> IOP.inspect("convex_polygon")
    assert convex_polygon.convex
    concave_polygon =
      points
      |> Enum.reverse
      |> Enum.map(&Position.to_vertex/1)
      |> Collision.Polygon.from_vertices
      #|> IOP.inspect("concave_polygon")
    refute concave_polygon.convex
  end
end
