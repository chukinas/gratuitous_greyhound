defmodule Spatial.Geometry.Circle do

  use Spatial.LinearAlgebra
  use Spatial.Math
  use Spatial.PositionOrientationSize
  use TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    csys_fields()
    field :radius, number
    field :rotation, :cw | :ccw
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(csys, radius, rotation)
  when is_csys(csys)
  and radius > 0
  and rotation in [:cw, :ccw] do
    fields =
      %{
        radius: radius,
        rotation: rotation
      }
      |> merge_csys(csys)
    struct!(__MODULE__, fields)
  end

  def from_tangent_csys_and_other_coord(tangent_csys, coord) do
    signed_radius = signed_radius(coord, tangent_csys)
    radius = abs(signed_radius)
    rotation = if signed_radius < 0, do: :ccw, else: :cw
    center_csys = center_csys(tangent_csys, radius, rotation)
    new(center_csys, radius, rotation)
  end

  def from_tangent_and_position(tangent_pose, other_position_on_circle)
  when has_pose(tangent_pose)
  and has_position(other_position_on_circle) do
    # TODO deprecate these two from funcs, replace w/ similar that take linalg args
    tangent_csys = csys_from_pose tangent_pose
    coord = other_position_on_circle |> vector_from_position
    from_tangent_csys_and_other_coord(tangent_csys, coord)
  end

  def from_tangent_distance_angle_direction(tangent_csys, trav_distance, trav_angle, direction)
  # TODO guard for tangent_csys
  when trav_distance > 0
  and is_number(trav_angle)
  and direction in [:cw, :ccw] do
    radius = radius_from_angle_and_arclen(trav_angle, trav_distance)
    center_csys = tangent_csys |> center_csys(radius, direction)
    new(center_csys, radius, direction)
  end

  # *** *******************************
  # *** CONVERTERS

  # TODO use LinAlg fun instead
  def csys(circle), do: circle |> csys_from_map

  def radius(%__MODULE__{radius: value}), do: value

  def diameter(%__MODULE__{radius: value}), do: value * 2

  def circumference(circle) do
    circle
    |> radius
    |> mult(2 * :math.pi())
  end

  def sign_of_rotation(%__MODULE__{rotation: :cw}),  do:  1
  def sign_of_rotation(%__MODULE__{rotation: :ccw}), do: -1

  def coord(%__MODULE__{location: value}), do: value

  # *** *******************************
  # *** PRIVATE HELPERS

  defp signed_radius(point_coords, tangent_csys)
  when is_vector(point_coords)
  and is_csys(tangent_csys) do
    {x, y} = _other_coordintate_wrt_tangent_csys =
      point_coords
      |> vector_wrt_inner_observer(tangent_csys)
    (x * x + y * y) / (2 * y)
  end

  defp center_csys(tangent_csys, radius, :cw), do: do_center_csys(tangent_csys, radius, :right)

  defp center_csys(tangent_csys, radius, :ccw), do: do_center_csys(tangent_csys, radius, :left)

  defp do_center_csys(tangent_csys, radius, direction) do
    tangent_csys
    |> csys_rotate(direction)
    |> csys_translate({:forward, radius})
    |> csys_rotate(:flip)
  end

  def rotation_direction(%__MODULE__{rotation: value}), do: value

  def rotation_direction(signed_rotation) when signed_rotation > 0, do: :cw

  def rotation_direction(signed_rotation) when signed_rotation < 0, do: :ccw

  @doc"""
  Returns a signed angle for a given arc length
  """
  def rotation_at_arclen(circle, arclen) when is_number(arclen) do
    IO.warn "rotation_at_arclen is deprecated"
    circle
    |> radius
    |> angle_from_radius_and_arclen(arclen)
    |> mult(sign_of_rotation(circle))
  end

  def arc_len_at_angle(%__MODULE__{} = circle, angle)
  when angle_is_normal(angle) do
    IO.warn "arc_len_at_angle is deprecated"
    traversal_distance_after_traversing_angle(circle, angle)
  end

  def tangent_pose_after_len(circle, arclen) do
    IO.warn "tangent_pose_after_len is deprecated"
    circle
    |> csys_after_traversing_distance(arclen)
    |> csys_to_pose
  end

  def rotate_in_direction_of_rotation(circle, angle) do
    angle = angle |> abs |> mult(sign_of_rotation(circle))
    circle |> csys_rotate(angle)
  end

  # *** *******************************
  # *** REDUCERS

  def csys_after_traversing_angle(circle, angle) do
    circle
    |> rotate_in_direction_of_rotation(angle)
    # TODO use a LinAlg func instead
    |> csys
    |> csys_translate_forward(circle |> radius)
    |> csys_rotate({:right_angle, circle |> sign_of_rotation})
  end

  def csys_after_traversing_distance(circle, distance) do
    trav_angle =
      circle
      |> traversal_angle_after_traversing_distance(distance)
    csys_after_traversing_angle(circle, trav_angle)
  end

  # *** *******************************
  # *** REDUCERS

  def coord_after_traversing_angle(circle, angle) do
    csys_after_traversing_angle(circle, angle)
    |> csys_to_coord_vector
  end

  def coord_after_traversing_distance(circle, distance) do
    trav_angle =
      circle
      |> traversal_angle_after_traversing_distance(distance)
    coord_after_traversing_angle(circle, trav_angle)
  end

  def traversal_angle_after_traversing_distance(circle, distance) do
    angle_from_radius_and_arclen(circle |> radius, distance)
  end

  @doc"""
  Traversal is movement along the circumference,
  in the direction of rotation, starting at the initial tangent pose.

  Returns the degrees traveled in the direction of rotation until
  meeting the line segment connecting circle center and coord arg.
  Always a positive number.
  """
  def traversal_angle_at_coord(circle, coord) do
    coord
    |> vector_wrt_inner_observer(circle)
    |> vector_to_angle
    |> mult(circle |> sign_of_rotation)
    |> normalize_angle
  end

  def traversal_distance_after_traversing_angle(circle, trav_angle) do
    arclen_from_radius_and_angle(circle |> radius, trav_angle)
  end

  def traversal_distance_at_coord(circle, coord) do
    trav_angle = traversal_angle_at_coord(circle, coord)
    circle
    |> radius
    |> arclen_from_radius_and_angle(trav_angle)
  end

end
