ExUnit.start()

defmodule Chukinas.LinearAlgebraTest do

  use ExUnit.Case, async: true
  alias Chukinas.LinearAlgebra.VectorCsys, as: V
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers
  import Chukinas.LinearAlgebra

  describe "vector coordinate system" do

    @sqrt2 :math.sqrt(2)

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

  end

end
