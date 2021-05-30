alias Chukinas.Geometry.Circle

defmodule Circle do

  use Chukinas.LinearAlgebra
  use Chukinas.Math
  use Chukinas.PositionOrientationSize
  use TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    csys_fields()
    field :radius, number
    field :rotation, :cw | :ccw
  end

  # *** *******************************
  # *** NEW

  def new(csys, radius, rotation)
  when has_csys(csys)
  and radius > 0 do
    fields =
      %{
        radius: radius,
        rotation: rotation
      }
      |> merge_csys(csys)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** FROM TANGENT AND POSITION

  def from_tangent_and_position(tangent_pose, other_position_on_circle)
  when has_pose(tangent_pose)
  and has_position(other_position_on_circle) do
    tangent_csys = csys_from_pose tangent_pose
    signed_radius =
      other_position_on_circle
      |> vector_from_position
      |> signed_radius(tangent_csys)
    center_csys = center_csys(tangent_csys, signed_radius)
    rotation = if signed_radius < 0, do: :ccw, else: :cw
    new(center_csys, abs(signed_radius), rotation)
  end

  def signed_radius(point_coords, tangent_csys)
  when is_vector(point_coords)
  and has_csys(tangent_csys) do
    {x, y} = _other_coordintate_wrt_tangent_csys =
      point_coords
      |> vector_wrt_csys(tangent_csys)
    (x * x + y * y) / (2 * y)
    |> abs
  end

  def center_csys(tangent_csys, signed_radius) do
    cond do
      signed_radius > 0 -> csys_right(tangent_csys)
      signed_radius < 0 -> csys_left(tangent_csys)
    end
    |> csys_forward(signed_radius)
    |> csys_180
  end

  # *** *******************************
  # *** GETTERS

  def csys(circle), do: circle |> csys_new

  def radius(%__MODULE__{radius: value}), do: value

  def circumference(circle) do
    circle
    |> radius
    |> Trig.mult(2 * :math.pi())
  end

  def sign_of_rotation(%__MODULE__{rotation: :ccw}), do: -1
  def sign_of_rotation(%__MODULE__{rotation: :cw}),  do:  1

  # *** *******************************
  # *** API

  def coord_at_angle(%__MODULE__{rotation: :ccw} = circle, angle) do
    coord_at_angle(circle, -angle)
  end

  def coord_at_angle(%__MODULE__{} = circle, angle) do
    circle
    |> csys
    |> vector_from_csys_and_polar(angle, circle |> radius)
  end

  @doc"""
  Returns a signed angle (neg for ccw, pos for cw)
  """
  def rotation_at(circle, position) when has_position(position) do
    position
    |> vector_from_position
    |> angle_of_vector_wrt_csys(circle)
    |> Trig.mult(circle |> sign_of_rotation)
  end

  def arc_len_at_angle(%__MODULE__{} = circle, angle)
  when angle_is_normal(angle) do
    circle
    |> circumference
    |> Trig.mult(360 / angle)
  end

end
