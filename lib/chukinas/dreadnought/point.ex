defmodule Chukinas.Dreadnought.Point do
  @moduledoc """
  Functions for manipulating points (cartesian x-y coordinates)
  """

  alias Chukinas.Dreadnought.Angle
  import Chukinas.Dreadnought.Guards

  @type t :: {number(), number()}
  @type list_of :: [t()]
  @type map_of :: %{atom() => t()}
  @type point_or_points :: t() | list_of() | map_of()

  # *** *******************************
  # *** FROM POLAR

  @doc """
  Calculate a point (cartesian) from polar coordinates

  ## Examples

      iex> alias Chukinas.Dreadnought.{Point, Angle}
      iex> angle = Angle.new(90)
      iex> Point.from_polar(angle, 1)
      ...> |> Point.set_precision(:int)
      {0, 1}
  """
  def from_polar(%Angle{}=angle, radius) when is_number(radius) do
    {radius, 0}
    |> rotate(angle)
  end 
  
  # *** *******************************
  # *** TRANSLATE

  @doc """
  Translate a point or points

  ## Examples

      iex> Chukinas.Dreadnought.Point.translate({1, 2.5}, {2, -0.5})
      {3, 2.0}

      iex> Chukinas.Dreadnought.Point.translate([{1, 2.5}, {0, 0}], {2, -0.5})
      [{3, 2.0}, {2, -0.5}]

      iex> Chukinas.Dreadnought.Point.translate(%{a: {1, 2.5}, b: {0, 0}}, {2, -0.5})
      %{a: {3, 2.0}, b: {2, -0.5}}
  """
  def translate(points, dxdy) when is_map(points) do
    points
    |> update_map_values(fn point -> translate(point, dxdy) end)
  end 
  def translate(coords, dxdy) when is_list(coords) do
    coords
    |> Enum.map(&translate(&1, dxdy))
    # TODO refactor above to use fn...
  end 
  def translate({x, y}=point, {dx, dy}=dxdy) when is_point(point) and is_point(dxdy) do
    {x + dx, y + dy}        
  end 

  # *** *******************************
  # *** ROTATE
  
  @doc """
  Rotate a point or points about the {0, 0} point

  As in classic trigonometry, a COUNTERclockwise angle is positive; a clockwise one negative.

  ## Examples

      iex> a = 2
      iex> a == 2
      true

      iex> alias Chukinas.Dreadnought.{Angle, Point}
      iex> point = {0, 1}
      iex> angle = Angle.new(90)
      iex> Point.rotate(point, angle) |> Point.set_precision()
      {-1.0, 0.0}

      iex> alias Chukinas.Dreadnought.{Angle, Point}
      iex> point = {2, 0}
      iex> rotation_point = {4, 0}
      iex> angle = Angle.new(180)
      iex> Point.rotate(point, angle, rotation_point) |> Point.set_precision(:int)
      {6, 0}

      iex> alias Chukinas.Dreadnought.{Angle, Point}
      iex> angle = Angle.new(180)
      iex> Point.rotate([{1, 2.5}, {0, 0}], angle) |> Point.set_precision(1)
      [{-1.0, -2.5}, {0.0, 0.0}]

      iex> alias Chukinas.Dreadnought.{Angle, Point}
      iex> angle = Angle.new(90)
      iex> Point.rotate(%{a: {1, 2}, b: {0, 0}}, angle) |> Point.set_precision()
      %{a: {-2.0, 1.0}, b: {0.0, 0.0}}
  """
  def rotate(points, angle, rotation_point \\ {0, 0})
  def rotate(points, angle, rotation_point) when is_map(points) do
    points
    |> update_map_values(&rotate(&1, angle, rotation_point))
  end 
  def rotate(points, angle, rotation_point) when is_list(points) do
    points
    |> Enum.map(&rotate(&1, angle, rotation_point))
  end 
  def rotate({x, y}=point, %Angle{rad: angle}, {0, 0}) when is_point(point) do
    {
      (x * :math.cos(angle)) - (y * :math.sin(angle)),
      (y * :math.cos(angle)) + (x * :math.sin(angle))
    }
  end 
  def rotate(point, angle, rotation_point) when is_point(rotation_point) do
    point
    |> subtract(rotation_point)
    |> rotate(angle, {0, 0})
    |> add(rotation_point)
  end 

  # *** *******************************
  # *** MIRROR

  @doc """
  Mirror a point vertically, about the x-axis

  ## Examples

      iex> Chukinas.Dreadnought.Point.mirror_x({2, -3.5})
      {2, 3.5}
  """
  @spec mirror_x(t()) :: t()
  def mirror_x({x, y}) do
    {x, -y}
  end

  @doc """
  Mirror a point horizontally, about the y-axis

  ## Examples

      iex> Chukinas.Dreadnought.Point.mirror_y({2, -3.5})
      {-2, -3.5}
  """
  @spec mirror_y(t()) :: t()
  def mirror_y({x, y}) do
    {-x, y}
  end

  @doc """
  Mirror a point about the origin, essentially rotating it 180 deg

  ## Examples

      iex> Chukinas.Dreadnought.Point.mirror({2, -3.5})
      {-2, 3.5}
  """
  @spec mirror(t()) :: t()
  def mirror({x, y}) do
    {-x, -y}
  end

  # *** *******************************
  # *** ADD, SUBTRACT
  
  @doc """
  Add two points

  Same in function to the simple form of translate.

  ## Examples

      iex> alias Chukinas.Dreadnought.Point
      iex> Point.add({1, 2.5}, {2, -0.5})
      {3, 2.0}
  """
  def add(point1, point2) when is_point(point1) and is_point(point2) do
    translate(point1, point2)
  end

  @doc """
  Subtract second point from first point

  ## Examples

      iex> alias Chukinas.Dreadnought.Point
      iex> Point.subtract({1, 2.5}, {2, -0.5})
      {-1, 3.0}
  """
  def subtract(point1, point2) when is_point(point1) and is_point(point2) do
    translate(point1, mirror(point2))
  end

  # *** *******************************
  # *** SET PRECISION

  def set_precision(points, precision \\ 0)
  def set_precision(points, precision) when is_list(points) do
    points
    |> Enum.map(&set_precision(&1, precision))
  end
  def set_precision(points, precision) when is_map(points) do
    points
    |> update_map_values(fn point -> set_precision(point, precision) end)
  end
  def set_precision({x, y}=point, precision) when is_point(point) do
    {
      round_number(x, precision),
      round_number(y, precision),
    }   
  end

  defp round_number(number, :int) do
    number |> round()
  end
  defp round_number(number, precision) when is_integer(precision) do
    Float.round(number * 1.0, precision)
  end

  # *** *******************************
  # *** HELPERS

  defp update_map_values(map, update_func) do
    map
    |> Enum.map(fn {key, point} -> {key, update_func.(point)} end)
    |> Enum.into(%{})
  end

end
