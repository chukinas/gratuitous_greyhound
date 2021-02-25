ExUnit.start()

# TODO this file isn't in the right place?
defmodule PathTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "calculate end pose of straight path" do
    actual_end_pose =
      Path.new(
        pose: Pose.origin(),
        length: 1
      )
      |> Path.get_end_pose()
    expected_end_pose = Pose.new(1, 0, 0)
    assert match_numerical_map? expected_end_pose, actual_end_pose
  end

  test "calculate end pose of turn path" do
    actual_end_pose =
      Path.new(
        pose: Pose.new(0, -1, 0),
        length: :math.pi() / 2,
        angle: 90
      )
      |> Path.get_end_pose()
    expected_end_pose = Pose.new(1, 0, 90)
    assert match_numerical_map? expected_end_pose, actual_end_pose
  end

  test "SVG for 90deg turn" do
    actual_svg =
      Path.new(
        pose: Pose.origin(),
        length: :math.pi() / 2,
        angle: 90
      )
      |> Svg.get_path_string()
    expected_svg = "M 0 0 Q 1 0 1 1"
    assert actual_svg == expected_svg
  end
end
