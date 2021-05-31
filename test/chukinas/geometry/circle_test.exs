ExUnit.start()

defmodule Chukinas.LinearAlgebra.CircleTest do

  use ExUnit.Case, async: true
  alias Chukinas.LinearAlgebra.VectorCsys, as: V
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers
  use Chukinas.LinearAlgebra
  alias Chukinas.Math
  alias Chukinas.Geometry.Circle

  describe "circle" do

    @sqrt2 :math.sqrt(2)

    # For an r=1 circle centered on origin:
    @origin_circle Circle.new(csys_origin(), 1, :ccw)
    @circumference 2 * :math.pi() * 1

    test "from pose and position" do
      pose = pose_new(1, 0, 270)
      position = position_new(0, 1)
      circle = Circle.from_tangent_and_position(pose, position)
      assert circle = @origin_circle
    end

    test "from tangent, arclen, and rotation" do
      pose = pose_new(1, 0, 270)
      # Assuming a 90deg turn...
      radius = 1
      arclen = Math.arclen_from_radius_and_angle(radius, 90)
      rotation = -90
      circle = Circle.from_tangent_len_rotation(pose, arclen, rotation)
      assert circle = @origin_circle
      assert 1 == Circle.radius(circle)
      assert 2 * :math.pi() == Circle.circumference(circle)
      assert :ccw == circle.rotation
      assert 1 == circle |> Circle.radius
    end

    test "get props from circle" do
      assert_tuple_approx_equal(
        {0, -1},
        Circle.coord_after_traversing_angle(@origin_circle, 90)
      )
    end

    test "traversal angle and distance at coord" do
      coord = {1, -1}
      assert 45 == Circle.traversal_angle_at_coord(@origin_circle, coord)
      assert_in_delta(
        @circumference / 8,
        Circle.traversal_distance_at_coord(@origin_circle, coord),
        0.1
      )
    end

  end

end
