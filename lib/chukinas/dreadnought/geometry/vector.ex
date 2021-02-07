defmodule Chukinas.Dreadnought.Vector do
  @moduledoc """
  Struct and functions for operating on vectors.

  Given a vector (i.e. a point and an orientation), we can...
  - move along it some distance in a straight line
  - follow an arc to the right or left until some distance or orientation is reached
  """

  alias Chukinas.Dreadnought.Angle
  alias Chukinas.Dreadnought.Point
  import Chukinas.Dreadnought.Guards

  # *** *******************************
  # *** TYPE

  use TypedStruct

  typedstruct enforce: true do
    # X,Y coordinates measured from the top left.
    field :point, Point.t()

    # Zero points to the right, in the direction of positive X
    # A positive angle opens in the direction of positive y,
    # i.e. counterclockwise, as in standard geometry.
    # The catch when working with SVGs is that they have positive Y
    # pointing down. So in this mirrored perspective, a positive angle will
    # look like clockwise rotation to the user.
    field :angle, Angle.t()
  end

  # *** *******************************
  # *** NEW

  @doc """
  Construct new Vector struct

  ## Examples

      iex> Vector.new(1, 2, 0)
      %Vector{point: {1, 2}, angle: %Chukinas.Dreadnought.Angle{deg: 0, deg_abs: 0, negative?: false, rad: 0.0, rad_abs: 0.0}}

      iex> point = {1, 2}
      iex> angle = Chukinas.Dreadnought.Angle.new(0)
      iex> Vector.new(point, angle)
      %Vector{point: {1, 2}, angle: %Chukinas.Dreadnought.Angle{deg: 0, deg_abs: 0, negative?: false, rad: 0.0, rad_abs: 0.0}}
  """
  def new(x, y, angle_deg) when is_number(x) and is_number(y) and is_number(angle_deg) do
    %__MODULE__{
      point: {x, y},
      angle: Angle.new(angle_deg)
    }
  end
  def new(point, %Angle{} = angle) when is_point(point) do
    %__MODULE__{
      point: point,
      angle: angle
    }
  end

  # *** *******************************
  # *** GETTERS

  def get_point(vector), do: vector.point
  def get_angle(vector), do: vector.angle

  # *** *******************************
  # *** TO MAP

  @doc """
  Get a simplified representation of a Vector struct

  Originally created to ease the process of writing this modules's doctests.

  ## Examples

      iex> Vector.new(1, 2, 90)
      ...> |> Vector.to_map()
      %{x: 1, y: 2, angle_deg: 90}
  """
  def to_map(vector, precision \\ :noop)
  def to_map(%__MODULE__{} = vector, :noop) do
    {x, y} = vector.point
    %{
      x: x,
      y: y,
      angle_deg: vector.angle.deg
    }
  end
  # TODO Precision keeps cropping up. Make a new module for it?
  def to_map(%__MODULE__{} = vector, :int) do
    {x, y} = vector.point
    %{
      x: round(x),
      y: round(y),
      angle_deg: round(vector.angle.deg)
    }
  end

  # *** *******************************
  # *** MOVE STRAIGHT

  @doc """
  Move some distance along the vector

  ## Examples

      iex> Vector.new(1, 2, 90)
      ...> |> Vector.move_straight(1)
      ...> |> Vector.to_map()
      %{x: 1.0, y: 3.0, angle_deg: 90}
  """
  def move_straight(%__MODULE__{} = vector, distance) do
    vector.angle
    |> Point.from_polar(distance)
    |> Point.add(vector.point)
    |> new(vector.angle)
  end

  # *** *******************************
  # *** SPIN

  @doc """
  Change a vector's orientation

  ## Examples

      iex> Vector.new(1, 2, 90)
      ...> |> Vector.spin(-45)
      ...> |> Vector.to_map()
      %{x: 1, y: 2, angle_deg: 45}
  """
  def spin(%__MODULE__{} = vector, angle_deg) when is_number(angle_deg) do
    %{vector | angle: Angle.new(vector.angle.deg + angle_deg)}
  end

  # *** *******************************
  # *** FIND CENTER OF ROTATION

  @doc """
  Given radius and sign (+/-) of a turn, return point at center of rotation

  ## Examples

      iex> alias Chukinas.Dreadnought.Point
      iex> Vector.new(0, 0, 90)
      ...> |> Vector.find_center_of_rotation(1, -123)
      ...> |> Point.set_precision(:int)
      {1, 0}
  """
  def find_center_of_rotation(%__MODULE__{} = vector, radius, angle_sign) when is_number(radius) and is_number(angle_sign) do
    spin_90 = 90 * get_sign_of_angle(angle_sign)
    vector
    |> spin(spin_90)
    |> move_straight(radius)
    |> get_point()
  end

  # *** *******************************
  # *** MOVE_ALONG_ARC

  @doc """


  ## Examples

      iex> Vector.new(0, 0, 90)
      ...> |> Vector.move_along_arc(3.14, -180)
      ...> |> Vector.to_map(:int)
      %{x: 2, y: 0, angle_deg: -90}
  """
  # TODO make sure angle is not zero
  def move_along_arc(%__MODULE__{} = vector, arc_length, angle_deg) when is_number(arc_length) and is_number(angle_deg) do
    turn_angle = Angle.new(angle_deg)
    turn_radius = abs(arc_length / turn_angle.rad)
    rotation_point = find_center_of_rotation(vector, turn_radius, angle_deg)
    vector_angle_end = Angle.add(vector.angle, turn_angle)
    vector
    |> get_point()
    |> Point.rotate(turn_angle, rotation_point)
    |> new(vector_angle_end)
  end

  # *** *******************************
  # *** Y-INTERCEPT

  @doc """
  Find a vector's y-intercept

  ## Examples

      iex> Vector.new(1, 1, 0)
      ...> |> Vector.get_y_intercept()
      ...> |> Chukinas.Dreadnought.Point.set_precision(:int)
      {0, 1}

      iex> Vector.new(1, 1, 45)
      ...> |> Vector.get_y_intercept()
      ...> |> Chukinas.Dreadnought.Point.set_precision(:int)
      {0, 0}
  """
  def get_y_intercept(%__MODULE__{} = vector) do
    {x, y} = vector.point
    slope = :math.tan(vector.angle.rad)
    intercept = y - slope * x
    {0, intercept}
  end

  # *** *******************************
  # *** MOVE WITH VECTOR

  @doc """
  Move a collection of points from one vector to another

  ## Examples

      iex> alias Chukinas.Dreadnought.Point
      iex> points = [{-1, 0}, {1, 0}]
      iex> vector_start = Vector.new(0, 0, 90)
      iex> vector_end = Vector.new(5, 0, 0)
      iex> Vector.move_with_vector(points, vector_start, vector_end)
      ...> |> Point.set_precision(:int)
      [{5, 1}, {5, -1}]
  """
  def move_with_vector(points, %__MODULE__{} = vector_start, %__MODULE__{} = vector_end) do
    translation = Point.subtract(vector_end.point, vector_start.point)
    rotation = Angle.subtract(vector_end.angle, vector_start.angle)
    points
    |> Point.translate(translation)
    |> Point.rotate(rotation, vector_end.point)
  end

  # TODO move this to a different module
  def get_sign_of_angle(angle) do
    round(angle / abs(angle))
  end
end
