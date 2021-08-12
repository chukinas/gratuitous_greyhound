ExUnit.start()

defmodule Dreadnought.LinearAlgebraTest do

  alias Dreadnought.Math
  use Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize
  use Dreadnought.TestHelpers
  use ExUnit.Case, async: true

  describe "VectorApi:" do

    test "vector_to_angle" do
      vector = vector_new(61, -61)
      expected_angle = 360 - 45
      actual_angle = vector_to_angle(vector)
      assert_in_delta(expected_angle, actual_angle, 0.5)
    end

  end

  describe "TransformApi:" do

    test "invert" do
      pose = pose_new(1, 1, -90)
      csys = csys_from_pose(pose)
      expected_inverted_csys =
        pose_new(1, -1, 90)
        |> csys_from_pose
      actual_inverted_csys =
        csys
        |> csys_invert
      assert expected_inverted_csys == actual_inverted_csys
    end

    @observer_csys csys_from_orientation_and_coord({1, -1}, {762.5, 787.5})
    @target_coord {775, 275}

    test "coord wrt a csys" do
      assert_tuple_approx_equal(
        {371.2, -353.6},
        vector_wrt_inner_observer(@target_coord, @observer_csys)
      )
    end

    test "polar coord angle of target as seen from observer" do
      expected_angle = Math.normalize_angle(-44)
      actual_angle =
        vector_wrt_inner_observer(@target_coord, @observer_csys)
        |> vector_to_angle
      assert_in_delta(expected_angle, actual_angle, 1)
    end

    test "angle wrt a csys, small" do
      csys = csys_origin()
      coord = vector_new(1, -1)
      assert_in_delta(
        Math.normalize_angle(-45),
        vector_wrt_outer_observer(coord, csys) |> vector_to_angle,
        1
      )
    end

  end

  describe "vector transforms" do

    def unit, do: pose_new(1, 1, 90)

    def mount, do: pose_new(2, 0, 180)

    test "get world origin wrt unit" do
      assert_approx_equal :vector, {-1, 1}, vector_wrt_inner_observer(vector_origin(), unit())
    end

    test "get world origin wrt mount" do
      assert_approx_equal {3, -1}, vector_wrt_inner_observer(vector_origin(), [unit(), mount()])
    end

    test "get world {10, 10} wrt mount" do
      assert_approx_equal {-7, 9}, vector_wrt_inner_observer({10, 10}, [unit(), mount()])
    end

    test "get angle b/w mount and target" do
      # Note, it is irrelevant the current orientation of the turret.
      # When getting mount angles, the angle is the angle wrt unit orientation
      target = {2, 4}
      turret = mount() |> vector_from_position
      actual_angle = Math.normalize_angle(-45)
      assert actual_angle == vector_wrt_inner_observer(target, [unit(), turret]) |> vector_to_angle
    end

    test "get world coord for gun barrel" do
      turret_barrel = {20, 0}
      turret_csys = csys_new(20, 0, 90)
      unit_csys = csys_new(20, 0, 90)
      actual_coord =
        vector_wrt_outer_observer(turret_barrel, [
          turret_csys,
          unit_csys
        ])
      expected_world_coord = {0, 20}
      assert expected_world_coord == actual_coord
    end

  end

  describe "csys api" do

    test "coord origin" do
      coord_vector =
        csys_origin()
        |> csys_to_coord_vector
      assert {0, 0} == coord_vector
    end

  end

end
