defmodule Spatial.LinearAlgebra.Vector do

  alias Spatial.Math
  alias Spatial.PositionOrientationSize, as: POS


  @x {1, 0}
  @y {0, 1}
  @type t() :: {number(), number()}

  # *** *******************************
  # *** CONSTRUCTORS

  def new(x, y), do: {x, y}

  def from_angle(degrees) do
    {sin, cos} = Math.sin_and_cos(degrees)
    {cos, sin}
  end

  # *** *******************************
  # *** REDUCERS

  def flip_sign(vector), do: scalar(vector, -1)

  def flip_sign_y({x, y}), do: {x, -y}

  def normalize({a, b} = vector) do
    magnitude = magnitude(vector)
    (for var <- [a, b], do: var / magnitude)
    |> List.to_tuple
  end

  def rotate_180({x, y}), do: {-y, -x}

  def scalar({x, y}, scalar), do: {x * scalar, y * scalar}

  def subtract(a, b), do: b |> rotate_180 |> sum(a)

  def sum({a, b}, {c, d}), do: {a + c, b + d}

  # *** *******************************
  # *** CONVERTERS

  def angle(vector) do
    unsigned_angle =
      vector
      |> normalize
      |> dot(@x)
      |> Math.acos
    y_axis_projection_sign =
      vector
      |> dot(@y)
      |> Math.sign
    Math.normalize_angle(unsigned_angle * y_axis_projection_sign)
  end

  def dot({a, b}, {c, d}), do: a * c + b * d

  def magnitude({x, y}) do
    [x, y]
    |> Enum.map(&:math.pow(&1, 2))
    |> Enum.sum
    |> :math.sqrt
  end

  def vector_to_position({x, y}), do: POS.position_new(x, y)

end
