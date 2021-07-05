ExUnit.start()

defmodule CollisionTest do

  use ExUnit.Case, async: true
  use DreadnoughtHelpers
  use Chukinas.PositionOrientationSize

  test "get squares which include a target shape" do
    count_overlapping_squares = fn target ->
      %{square_size: 100, x_count: 1, y_count: 2}
      |> Grid.new
      |> Grid.squares(include: target, threshold: 1)
      |> Enum.count
    end
    [
      {Rect.from_positions(10, 10, 90, 90), 1},
      {Rect.from_positions(10, 10, 90, 190), 2},
      {Rect.from_positions(10, 110, 90, 190), 1},
      {Rect.from_positions(150, 50, 200, 200), 0}
    ]
    |> Enum.each(fn {target, expected_count} ->
      assert expected_count == count_overlapping_squares.(target)
    end)
  end

end
