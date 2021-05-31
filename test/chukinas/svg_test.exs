alias Chukinas.Paths

ExUnit.start()

defmodule Chukinas.SvgTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "svg path string from straight path" do
    assert "M 0 0 L 10 0" = Paths.new_straight(0, 0, 0, 10) |> Svg.get_path_string()
  end

  test "SVG for 90deg turn" do
    actual_svg =
      Paths.new(
        pose: Pose.origin(),
        length: :math.pi() / 2,
        angle: 90
      )
      |> Svg.get_path_string()
    expected_svg = "M 0 0 Q 1 0 1 1"
    assert expected_svg == actual_svg
  end

  test "SVG for 180deg turn" do
    actual_svg =
      Paths.new(
        pose: Pose.origin(),
        length: :math.pi(),
        angle: 180
      )
      |> Svg.get_path_string()
    expected_svg = "M 0 0 Q 1 0 1 1 Q 1 2 0 2"
    assert expected_svg == actual_svg
  end

  test "SVG for 45deg turn" do
    start_pt = :math.sqrt(100 * 100 / 2)
    actual_svg =
      Paths.new(
        pose: Pose.new(-start_pt, start_pt, 45),
        length: :math.pi() * 100 / 4,
        angle: -45
      )
      |> Svg.get_path_string()
    expected_svg = "M -71 71 Q -41 100 0 100"
    assert expected_svg == actual_svg
  end

end
