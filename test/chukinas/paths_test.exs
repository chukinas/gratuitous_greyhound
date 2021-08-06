ExUnit.start()

defmodule Chukinas.PathsTest do

  use ExUnit.Case, async: true
  use Chukinas.BoundingRect
  use Chukinas.TestHelpers
  use Chukinas.PositionOrientationSize
  import Chukinas.Math
  alias Chukinas.Paths

  # TODO move this out to helpers module
  def assert_equal(val1, val2), do: assert_in_delta(val1, val2, 0.01)

  def assert_same_angle(%{angle: a}, %{angle: b}) do
    assert_equal normalize_angle(a), normalize_angle(b)
  end

  def assert_same_position(position1, {x, y}), do: assert_same_position(position1, %{x: x, y: y})
  def assert_same_position(position1, position2) do
    assert assert_equal(position1.x, position2.x)
    assert assert_equal(position1.x, position2.x)
  end

  def assert_same_pose(a, b) do
    assert_same_position a, b
    assert_same_angle a, b
  end

  test "end position of vertical straight path" do
    Paths.new_straight(0, 0, 90, 10)
    |> Paths.get_end_pose()
    |> assert_same_position({0, 10})
  end

  test "end position of horizontal straight path" do
    Paths.new_straight(0, 0, 0, 10)
    |> Paths.get_end_pose()
    |> assert_same_position({10, 0})
  end

  test "bounding rect of 45deg straight path" do
    path = Paths.new_straight(0, 0, 45, :math.sqrt(2))
    actual_rect = BoundingRect.of(path)
    expected_rect = Rect.from_size(1, 1)
    assert match_numerical_map? expected_rect, actual_rect
  end

  test "arc length" do
    radius = 100
    angle = 180
    expected_length = radius * :math.pi()
    actual_length = arclen_from_radius_and_angle(radius, angle)
    assert ^expected_length = actual_length
  end

  def test_connecting_path(start_pose, end_position) do
    actual_end_pose =
      start_pose
      |> Paths.get_connecting_path(end_position)
      |> Paths.get_end_pose
    assert_same_position(end_position, actual_end_pose)
  end

  test "get connecting (turn) path" do
    start_pose = pose_origin()
    # desired values
    radius = 100
    angle = 90
    length = arclen_from_radius_and_angle(radius, angle)
    path = Paths.new_turn start_pose, length, angle
    end_pose =
      Paths.get_end_pose(path)
    # Actual Values
    actual_end_pose =
      Paths.get_connecting_path(start_pose, end_pose)
      |> Paths.get_end_pose
    # Test
    assert match_numerical_map? end_pose, actual_end_pose
  end
  test "calculate end pose of straight path" do
    actual_end_pose =
      Paths.new(
        pose: pose_origin(),
        length: 1
      )
      |> Paths.get_end_pose()
    expected_end_pose = pose_new(1, 0, 0)
    assert match_numerical_map? expected_end_pose, actual_end_pose
  end

  test "calculate end pose of turn path" do
    actual_end_pose =
      Paths.new(
        pose: pose_new(0, -1, 0),
        length: :math.pi() / 2,
        angle: 90
      )
      |> Paths.get_end_pose()
    expected_end_pose = pose_new(1, 0, 90)
    assert match_numerical_map? expected_end_pose, actual_end_pose
  end

  describe "turn path" do

    test "connecting to a point" do
      # TODO move this to more general PathsTest
      start_pose = pose_new(1, 0, 90)
      should_end_pose = pose_new(0, 1, 180)
      connecting_path = Paths.get_connecting_path(start_pose, should_end_pose)
      actual_end_pose = Paths.pose_at_end(connecting_path)
      assert_pose_approx_equal should_end_pose, actual_end_pose
    end

    test "connecting to a real point" do
      # TODO move this to more general PathsTest
      start_pose = pose_new(1125, 425, 225)
      should_end_position = position_new(775, 275)
      connecting_path = Paths.get_connecting_path(start_pose, should_end_position)
      actual_end_position = Paths.position_at_end(connecting_path)
      assert (connecting_path |> Paths.length_from_path) > 0
      assert_position_approx_equal should_end_position, actual_end_position
    end

  end

end
