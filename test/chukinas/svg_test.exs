alias Chukinas.Paths

ExUnit.start()

defmodule Chukinas.SvgTest do
  use ExUnit.Case, async: true
  use Chukinas.PositionOrientationSize
  alias Chukinas.Svg

  test "svg path string from straight path" do
    assert "M 0 0 L 10 0" = Paths.new_straight(0, 0, 0, 10) |> Svg.get_path_string()
  end

  @radius 100
  @pose pose_origin()
  @circumference :math.pi() * 2 * @radius
  # TODO replace with func from Paths module

  def create_path(angle) do
    Paths.new(
        pose: @pose,
        length: @circumference * angle / 360,
        angle: angle
    )
  end

  test "SVG for 45deg turn" do
    actual_svg =
      45
      |> create_path
      |> Svg.get_path_string()
    expected_svg = "M 0 0 A 100 100 0 0 1 71 29"
    assert expected_svg == actual_svg
  end

  test "SVG for 90deg turn" do
    actual_svg =
      90
      |> create_path
      |> Svg.get_path_string()
    expected_svg = "M 0 0 A 100 100 0 0 1 100 100"
    assert expected_svg == actual_svg
  end

  test "SVG for 180deg turn" do
    actual_svg =
      180
      |> create_path
      |> Svg.get_path_string()
    expected_svg = "M 0 0 A 100 100 0 0 1 0 200"
    assert expected_svg == actual_svg
  end

end
