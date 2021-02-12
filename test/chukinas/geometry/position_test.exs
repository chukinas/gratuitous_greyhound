alias Chukinas.Geometry.{PositionTest, Position, Pose, Point}

ExUnit.start()

defmodule PositionTest do
  use ExUnit.Case, async: true

  test "to tuple" do
    assert {0, 0} = Point.new(0, 0) |> Position.to_tuple()
    assert {0, 0} = Pose.new(0, 0, 0) |> Position.to_tuple()
  end

  test "translate" do
    assert {1, 1} = Point.new(0, 0) |> Position.translate({1, 1}) |> Position.to_tuple()
  end
end
