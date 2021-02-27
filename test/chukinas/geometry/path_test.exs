ExUnit.start()

defmodule Chukinas.Geometry.PathTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  def assert_equal(val1, val2), do: assert_in_delta(val1, val2, 0.01)

  def assert_position(position1, {x, y}), do: assert_position(position1, %{x: x, y: y})
  def assert_position(position1, position2) do
    assert assert_equal(position1.x, position2.x)
    assert assert_equal(position1.x, position2.x)
  end

  test "end position of vertical straight path" do
    Straight.new(0, 0, 90, 10)
    |> Path.get_end_pose()
    |> assert_position({0, 10})
  end

  test "end position of horizontal straight path" do
    Straight.new(0, 0, 0, 10)
    |> Path.get_end_pose()
    |> assert_position({10, 0})
  end

  test "bounding rect of 45deg straight path" do
    path = Straight.new(0, 0, 45, :math.sqrt(2))
    actual_rect = path
    |> Path.get_bounding_rect()
    expected_rect = Rect.new(0, 0, 1, 1)
    assert match_numerical_map? expected_rect, actual_rect
  end
end
