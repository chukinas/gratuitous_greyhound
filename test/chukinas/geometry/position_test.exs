alias Chukinas.Geometry.{PositionTest, Position, Pose}

ExUnit.start()

defmodule PositionTest do
  use ExUnit.Case, async: true

  test "to tuple" do
    assert {0, 0} = Position.origin() |> Position.to_tuple()
    assert {0, 0} = Pose.origin() |> Position.to_tuple()
  end

  test "translate" do
    assert {1, 1} = Position.origin() |> Position.translate({1, 1}) |> Position.to_tuple()
  end
end
