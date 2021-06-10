ExUnit.start()

defmodule LinearAlgebra.VectorCsysTest do

  use ExUnit.Case, async: true
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  use Chukinas.TestHelpers

  describe "vector coordinate system" do

    @sqrt2 :math.sqrt(2)

    test "moving along x-axis" do
      assert {1, 0} ==
        pose_origin()
        |> csys_new
        |> csys_forward(1)
        |> coord_from_csys
    end

    test "moving along y-axis" do
      assert {0, 1} ==
        pose(0, 0, 90)
        |> csys_new
        |> csys_forward(1)
        |> coord_from_csys
    end

    test "rotating 45deg" do
      assert {0, 0} ==
        pose_origin()
        |> csys_new
        |> csys_rotate(45)
        |> coord_from_csys
    end

    test "rotating and moving a vcsys" do
      position_vector =
        pose_origin()
        |> csys_new
        |> csys_rotate(45)
        |> csys_forward(@sqrt2)
        |> coord_from_csys
      assert_tuple_approx_equal {1, 1}, position_vector
    end

  end

end
