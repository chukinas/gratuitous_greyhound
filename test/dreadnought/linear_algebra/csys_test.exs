defmodule LinearAlgebra.CsysTest do

  use ExUnit.Case, async: true
  use Dreadnought.PositionOrientationSize
  use Dreadnought.LinearAlgebra
  import Dreadnought.TestHelpers

  describe "vector coordinate system" do

    @sqrt2 :math.sqrt(2)

    test "moving along x-axis" do
      assert {1, 0} ==
        csys_origin()
        |> csys_translate_forward(1)
        |> csys_to_coord_vector
    end

    test "moving along y-axis" do
      assert {0, 1} ==
        csys_from_angle(90)
        |> csys_translate_forward(1)
        |> csys_to_coord_vector
    end

    test "rotating 45deg" do
      assert {0, 0} ==
        csys_from_angle(45)
        |> csys_to_coord_vector
    end

    test "rotating and moving a vcsys" do
      position_vector =
        csys_origin()
        |> csys_rotate(45)
        |> csys_translate_forward(@sqrt2)
        |> csys_to_coord_vector
      assert_tuple_approx_equal {1, 1}, position_vector
    end

  end

end
