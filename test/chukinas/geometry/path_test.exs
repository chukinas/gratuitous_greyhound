ExUnit.start()

defmodule Chukinas.Geometry.PathTest do
  alias Chukinas.Geometry.{Path}
  use ExUnit.Case, async: true

  def equal_position(position1, position2, accuracy \\ 0.01)
  def equal_position(position1, {x, y}, accuracy) do
    equal_position(position1, %{x: x, y: y}, accuracy)
  end
  def equal_position(position1, position2, accuracy) do
    assert position1.x / position2.x < (1 + accuracy)
    assert position1.y / position2.y < (1 + accuracy)
  end

  test "Add two straight paths" do
    Path.Straight.new(0, 0, 0, 10)
    |> Path.pose_end()
    |> equal_position({10, 0})
  end
end
