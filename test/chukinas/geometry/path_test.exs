ExUnit.start()

defmodule Chukinas.Geometry.PathTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  def assert_equal(val1, val2), do: assert_in_delta(val1, val2, 0.01)

  def assert_same_angle(%{angle: a}, %{angle: b}) do
    assert_equal Trig.normalize_angle(a), Trig.normalize_angle(b)
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
    Straight.new(0, 0, 90, 10)
    |> Path.get_end_pose()
    |> assert_same_position({0, 10})
  end

  test "end position of horizontal straight path" do
    Straight.new(0, 0, 0, 10)
    |> Path.get_end_pose()
    |> assert_same_position({10, 0})
  end

  test "bounding rect of 45deg straight path" do
    path = Straight.new(0, 0, 45, :math.sqrt(2))
    actual_rect =
      path
      |> Path.get_bounding_rect()
    expected_rect = Rect.new(0, 0, 1, 1)
    assert match_numerical_map? expected_rect, actual_rect
  end

  test "arc length" do
    radius = 100
    angle = 180
    expected_length = radius * :math.pi()
    actual_length = Trig.arc_length radius, angle
    assert ^expected_length = actual_length
  end

  test "get connecting paths" do
    [0, 90, 180, 270]
    |> Stream.map(&Pose.new(0, 0, &1))
    |> Enum.each(&test_90deg_turn/1)
  end

  test "why can ship not face left?" do
    start_pose = Pose.new(2900, 450, 80)
    end_position = Position.new(2895, 700)
    Trig.distance_between_points(start_pose, end_position)
    test_connecting_path start_pose, end_position
  end

  def test_connecting_path(start_pose, end_position) do
    actual_end_pose =
      start_pose
      |> Path.get_connecting_path(end_position)
      |> Path.get_end_pose
    assert_same_position(end_position, actual_end_pose)
  end

  def test_90deg_turn(start_pose) do
    # desired values
    radius = 100
    angle = -90
    length = Trig.arc_length radius, angle
    path = Path.new_turn start_pose, length, angle
    end_pose =
      Path.get_end_pose(path)
    # Actual Values
    actual_end_pose =
      Path.get_connecting_path(start_pose, end_pose)
      |> Path.get_end_pose
    # Test
    assert_same_pose end_pose, actual_end_pose
  end

  test "get connecting (turn) path" do
    start_pose = Pose.origin()
    # desired values
    radius = 100
    angle = 90
    length = Trig.arc_length radius, angle
    path = Path.new_turn start_pose, length, angle
    end_pose =
      Path.get_end_pose(path)
    # Actual Values
    actual_end_pose =
      Path.get_connecting_path(start_pose, end_pose)
      |> Path.get_end_pose
    # Test
    assert match_numerical_map? end_pose, actual_end_pose
  end
end
