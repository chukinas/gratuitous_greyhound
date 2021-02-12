ExUnit.start()

defmodule Chukinas.Geometry.PathTest do
  alias Chukinas.Geometry.{Path}
  use ExUnit.Case, async: true

  def assert_equal(val1, val2), do: assert_in_delta(val1, val2, 0.01)

  def assert_view_box(box, x, y, width, height) do
    %{x: x, y: y, width: width, height: height}
    |> Map.to_list()
    |> Enum.each(fn {key, value} -> assert_equal(box[key], value) end)
  end

  def assert_position(position1, {x, y}), do: assert_position(position1, %{x: x, y: y})
  def assert_position(position1, position2) do
    assert assert_equal(position1.x, position2.x)
    assert assert_equal(position1.x, position2.x)
  end

  test "end position of vertical straight path" do
    Path.Straight.new(0, 0, 90, 10)
    |> Path.pose_end()
    |> assert_position({0, 10})
  end

  test "end position of horizontal straight path" do
    Path.Straight.new(0, 0, 0, 10)
    |> Path.pose_end()
    |> assert_position({10, 0})
  end

  test "view box of a 45deg straight path" do
    Path.Straight.new(0, 0, 45, :math.sqrt(2))
    |> Path.view_box()
    |> assert_view_box(0, 0, 1, 1)
  end
end
