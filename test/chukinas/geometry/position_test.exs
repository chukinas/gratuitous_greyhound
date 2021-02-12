ExUnit.start()

defmodule Chukinas.Geometry.PositionTest do
  alias Chukinas.Geometry.{Position, Pose, Point}
  use ExUnit.Case, async: true

  # TODO do this for point as well
  test "to tuple" do
    assert {0, 0} = Point.new(0, 0) |> Position.to_tuple()
    assert {0, 0} = Pose.new(0, 0, 0) |> Position.to_tuple()
  end
end
