ExUnit.start()

defmodule Chukinas.Geometry.CircleTest do

  use ExUnit.Case, async: true
  use Chukinas.PositionOrientationSize
  use Chukinas.TestHelpers
  use Chukinas.LinearAlgebra
  alias Chukinas.Math
  alias Chukinas.Geometry.Circle

  describe "circle" do

    #@sqrt2 :math.sqrt(2)

    # For an r=1 circle centered on origin:
    @origin_circle Circle.new(csys_origin(), 1, :ccw)

    def circumference, do: 2 * :math.pi()

    test "from pose and position" do
      pose = pose_new(1, 0, 270)
      position = position_new(0, 1)
      circle = Circle.from_tangent_and_position(pose, position)
      assert circle == @origin_circle
    end

    test "from tangent, arclen, and rotation" do
      pose = pose_new(1, 0, 270)
      # Assuming a 90deg turn...
      radius = 1
      arclen = Math.arclen_from_radius_and_angle(radius, 90)
      rotation = -90
      circle = Circle.from_tangent_len_rotation(pose, arclen, rotation)
      assert circle == @origin_circle
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
        circumference() / 8,
        Circle.traversal_distance_at_coord(@origin_circle, coord),
        0.1
      )
    end

    test "from_tangent_and_position" do
      start_pose = pose_new(1125, 425, 225)
      should_end_position = position_new(775, 275)
      end_coord = should_end_position |> vector_from_position
      circle = Circle.from_tangent_and_position(start_pose, should_end_position)
      trav_angle_at_end_position = Circle.traversal_angle_at_coord(circle, end_coord)
      actual_end_coord = Circle.coord_after_traversing_angle(circle, trav_angle_at_end_position)
      assert_in_delta 43, trav_angle_at_end_position, 1
      assert -1 == circle |> Circle.sign_of_rotation
      assert_tuple_approx_equal end_coord, actual_end_coord
    end

    test "traversal_angle_at_coord" do
      circle = Circle.new(
        csys_from_orientation_and_coord(
          {0.707, -0.707},
          {762.5, 787.5}
        ),
        513,
        :ccw
      )
      assert :ccw == circle.rotation
      assert_in_delta(
        43,
        circle |> Circle.traversal_angle_at_coord({775, 275}),
        1
      )
    end

  end

end
