ExUnit.start()

defmodule LinearAlgebra.VectorCsysTest do

  use ExUnit.Case, async: true
  alias Chukinas.LinearAlgebra.VectorCsys, as: V
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers

  describe "vector coordinate system" do

    @sqrt2 :math.sqrt(2)

    test "moving along x-axis" do
      assert {1, 0} ==
        pose_origin()
        |> V.new
        |> V.forward(1)
        |> V.position
        |> position_to_tuple
    end

    test "moving along y-axis" do
      assert {0, 1} ==
        pose(0, 0, 90)
        |> V.new
        |> V.forward(1)
        |> V.position
        |> position_to_tuple
    end

    test "rotating 45deg" do
      assert {0, 0} ==
        pose_origin()
        |> V.new
        |> IOP.inspect("new, before rotate 45")
        |> V.rotate(45)
        |> IOP.inspect("rotate 45")
        |> V.position
        |> position_to_tuple
    end

    test "rotating and moving a vcsys" do
      position_vector =
        pose_origin()
        |> V.new
        |> V.rotate(45)
        |> V.forward(@sqrt2)
        |> V.position
        |> position_to_tuple
      assert_tuple_approx_equal {1, 1}, position_vector
    end

  end

end
