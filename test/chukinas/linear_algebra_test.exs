ExUnit.start()

defmodule Chukinas.LinearAlgebraTest do

  alias Chukinas.Math
  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers
  use ExUnit.Case, async: true

  describe "vector coordinate system" do

    @sqrt2 :math.sqrt(2)
    @coord_at_45 {@sqrt2 / 2, @sqrt2 / 2}

    test "inversion" do
      pose = pose_new(1, 1, -90)
      csys = csys_new(pose)
      should_inverted_csys =
        pose_new(1, -1, 90)
        |> csys_new
      actual_inverted_csys =
        csys
        |> csys_invert
      assert should_inverted_csys == actual_inverted_csys
    end

    test "coord ad polar coord" do
      csys = csys_origin()
      angle = 45
      radius = 1
      assert_tuple_approx_equal @coord_at_45, vector_from_csys_and_polar(csys, angle, radius)
    end

    @csys csys_from_orientation_and_coord({1, -1}, {762.5, 787.5})
    @coord {775, 275}

    test "coord wrt a csys" do
      assert_tuple_approx_equal(
        {371.2, -353.6},
        vector_wrt_csys(@coord, @csys)
      )
    end

    test "angle wrt a csys, large" do
      assert_in_delta(
        Math.normalize_angle(-44),
        angle_of_coord_wrt_csys(@coord, @csys),
        1
      )
    end

    test "angle wrt a csys, small" do
      csys = csys_origin()
      coord = coord_new(1, -1)
      assert_in_delta(
        Math.normalize_angle(-45),
        angle_of_coord_wrt_csys(coord, csys),
        1
      )
    end

  end

  describe "vector transforms" do

    def unit, do: pose_new(1, 1, 90)

    def mount, do: pose_new(2, 0, 180)

    test "get world origin wrt unit" do
      assert_approx_equal :vector, {-1, 1}, vector_transform_to(vector_origin(), unit())
    end

    test "get world origin wrt mount" do
      assert_approx_equal {3, -1}, vector_transform_to(vector_origin(), [unit(), mount()])
    end

    test "get world {10, 10} wrt mount" do
      assert_approx_equal {-7, 9}, vector_transform_to({10, 10}, [unit(), mount()])
    end

    test "get angle b/w mount and target" do
      target = {2, 4}
      turret = csys_new(2, 0, 0) |> coord_from_csys
      actual_angle = Math.normalize_angle(-45)
      assert actual_angle == vector_transform_to(target, [unit(), turret]) |> angle_from_vector
    end

    test "get world coord for gun barrel" do
      turret_barrel = {20, 0}
      turret_csys = csys_new(20, 0, 90)
      unit_csys = csys_new(20, 0, 90)
      actual_coord =
        vector_transform_from(turret_barrel, [
          turret_csys,
          unit_csys
        ])
      expected_world_coord = {0, 20}
      assert expected_world_coord == actual_coord
    end

  end

end
