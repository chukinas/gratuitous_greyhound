alias Chukinas.LinearAlgebra.{Vector}
alias Chukinas.Geometry.Trig

defmodule Vector.Guards do
  defguard is_vector(value)
    when tuple_size(value) == 2
    and elem(value, 0) |> is_number
    and elem(value, 1) |> is_number
end

defmodule Vector do
  import Vector.Guards

  @x {1, 0}
  #@y {0, 1}
  @type t() :: {number(), number()}

  # *** *******************************
  # *** NEW

  def new(x, y), do: {x, y}
  def new([x, y]), do: {x, y}
  def new(%{x: x, y: y}), do: {x, y}

  def origin, do: new(0, 0)

  def from_angle(degrees) do
    {sin, cos} = Trig.sin_and_cos(degrees)
    {cos, sin}
  end

  def from_sin_and_cos({sin, cos}), do: {cos, sin}

  def from_position(%{x: x, y: y}), do: {x, y}

  # *** *******************************
  # *** GETTERS

  # TODO Trig.sign should be moved to a new Math module
  def sign({_, y}), do: Trig.sign(y)
  def angle(vector) when is_vector(vector) do
    vector
    |> normalize
    |> dot(@x)
    |> Trig.acos
    |> Trig.mult(sign(vector))
    |> Trig.normalize_angle
  end
  def rotate_90({x, y}), do: {-y, x}

  # *** *******************************
  # *** API

  def flip(vector), do: scalar(vector, -1)
  def scalar({a, b}, scalar), do: {a * scalar, b * scalar}
  def dot({a, b}, {c, d}), do: a * c + b * d
  def add({a, b}, {c, d}), do: {a + c, b + d}
  def normalize({a, b}) do
    magnitude =
      [a, b]
      |> Enum.map(&:math.pow(&1, 2))
      |> Enum.sum
      |> :math.sqrt
    {
      a / magnitude,
      b / magnitude
    }
  end
  def sign_between(a, b) do
    a
    |> rotate_90
    |> dot(b)
    |> Trig.sign
  end
  def angle_between(a, b) do
    Trig.normalize_angle(sign_between(a, b) * angle_between_abs(a, b))
  end
  def angle_between_abs(a, b) do
    dot(a, b) |> Trig.acos
  end
end
