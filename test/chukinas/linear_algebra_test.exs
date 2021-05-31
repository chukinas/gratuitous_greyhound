ExUnit.start()

defmodule Chukinas.LinearAlgebraTest do

  use ExUnit.Case, async: true
  alias Chukinas.LinearAlgebra.VectorCsys, as: V
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers
  use Chukinas.LinearAlgebra
  use Chukinas.Math

  describe "vector coordinate system" do

    @sqrt2 :math.sqrt(2)
    @coord_at_45 {@sqrt2/2, @sqrt2/2}

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

    test "angle wrt a csys" do
      assert_in_delta(
        normalize_angle(-44),
        angle_of_vector_wrt_csys(@coord, @csys),
        1
      )
    end

  end

end
