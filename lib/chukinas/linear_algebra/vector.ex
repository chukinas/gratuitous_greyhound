defmodule Chukinas.LinearAlgebra.Vector do

  import Chukinas.Math

  @x {1, 0}
  @type t() :: {number(), number()}

  # *** *******************************
  # *** CONSTRUCTORS

  def new(x, y), do: {x, y}

  def from_angle(degrees) do
    {sin, cos} = sin_and_cos(degrees)
    {cos, sin}
  end

  # *** *******************************
  # *** REDUCERS

  def flip_sign(vector), do: scalar(vector, -1)

  def flip_sign_y({x, y}), do: {x, -y}

  # TODO rename ? `unit_vector`?
  def normalize({a, b} = vector) do
    magnitude = magnitude vector
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
    vector
    |> normalize
    |> dot(@x)
    |> acos
    |> mult(sign(vector))
    |> normalize_angle
  end

  def dot({a, b}, {c, d}), do: a * c + b * d

  def magnitude({x, y}) do
    [x, y]
    |> Enum.map(&:math.pow(&1, 2))
    |> Enum.sum
    |> :math.sqrt
  end

end
