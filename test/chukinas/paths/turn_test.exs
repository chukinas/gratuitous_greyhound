ExUnit.start()

defmodule Paths.TurnTest do

  use ExUnit.Case, async: true
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers
  import Chukinas.Paths

  describe "turn path" do

    test "connecting to a point" do
      # TODO move this to more general PathsTest
      start_pose = pose_new(1, 0, 90)
      should_end_pose = pose_new(0, 1, 180)
      connecting_path = get_connecting_path(start_pose, should_end_pose)
      actual_end_pose = pose_at_end(connecting_path)
      assert_pose_approx_equal should_end_pose, actual_end_pose
    end

    test "connecting to a real point" do
      # TODO move this to more general PathsTest
      start_pose = pose_new(1125, 425, 225)
      should_end_position = position_new(775, 275)
      connecting_path = get_connecting_path(start_pose, should_end_position)
      actual_end_position = position_at_end(connecting_path)
      assert (connecting_path |> length_from_path) > 0
      assert_position_approx_equal should_end_position, actual_end_position
    end

  end

end
