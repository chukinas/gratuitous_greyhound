ExUnit.start()

defmodule Chukinas.SvgTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "svg path string from straight path" do
    assert "M 0 0 L 10 0" = Path.new_straight(0, 0, 0, 10) |> Svg.to_string()
  end

  test "view box string from straight path" do
    path = Path.new_straight(0, 0, 45, :math.sqrt(2))
    assert "-10 -10 21 21" = path
    # TODO bounding rect should probably just be calculated from the get-go. I always need it. Just encapsulate it. No need to manually call it.
                             |> Path.get_bounding_rect()
      |> Svg.get_string(Path.get_start_pose(path), 10)
    # TODO margin should probably be set in a config file somewhere
  end
end
