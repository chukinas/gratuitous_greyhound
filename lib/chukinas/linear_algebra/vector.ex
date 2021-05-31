alias Chukinas.LinearAlgebra.{Vector}

# TODO move to Guard module
defmodule Vector.Guards do
  defguard is_vector(value)
    when tuple_size(value) == 2
    and elem(value, 0) |> is_number
    and elem(value, 1) |> is_number
end

defmodule Vector do

  import Vector.Guards
  import Chukinas.Math

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
    {sin, cos} = sin_and_cos(degrees)
    {cos, sin}
  end

  def from_sin_and_cos({sin, cos}), do: {cos, sin}

  def from_position(%{x: x, y: y}), do: {x, y}

  # *** *******************************
  # *** GETTERS

  # TODO add func that gets angle from two vectors
  def angle(vector) when is_vector(vector) do
    vector
    |> normalize
    # TODO put all the dots together
    |> dot(@x)
    |> acos
    |> IOP.inspect("vector angle")
    |> mult(sign(vector))
    |> IOP.inspect("vector angle after sign")
    |> normalize_angle
  end

  def rotate(vector, angle)
  when is_vector(vector)
  and is_number(angle) do
    angle
    |> from_angle
    |> matrix_dot_vector(vector)
  end

  def components(vector, :x), do: x_components(vector)
  def components(vector, :y), do: y_components(vector)
  # This is the top row of an orientation matrix
  def x_components({x, y}), do: {x, -y}
  # This is the botton row of an orientation matrix
  def y_components({x, y}), do: {y,  x}
  # This is the top row of an orientation matrix
  def x_axis({x, y}), do: {x,  y}
  # This is the botton row of an orientation matrix
  def y_axis({x, y}), do: {-y, x}

  def matrix_dot_matrix(matrix_a, matrix_b) do
    [x_axis(matrix_b), y_axis(matrix_b)]
    |> Enum.map(& matrix_dot_vector(matrix_a, &1))
    |> Enum.map(& elem(&1, 0))
    |> List.to_tuple
  end

  def matrix_dot_vector(matrix, vector) do
    for component <- [:x, :y] do
      matrix
      |> components(component)
      |> vector_dot_vector(vector)
    end
    |> List.to_tuple
  end

  def vector_dot_vector({a, b}, {c, d}) do
    a * c + b * d
  end

  def rotate_90({x, y}), do: {-y, x}

  def rotate_180({x, y}), do: {-y, -x}

  def magnitude({x, y}) do
    [x, y]
    |> Enum.map(&:math.pow(&1, 2))
    |> Enum.sum
    |> :math.sqrt
  end

  # *** *******************************
  # *** API

  # TODO rename flip_sign
  def flip(vector), do: scalar(vector, -1)

  def flip_sign(vector), do: scalar(vector, -1)

  def flip_sign_y({x, y}), do: {x, -y}

  def scalar({a, b}, scalar), do: {a * scalar, b * scalar}

  def dot({a, b}, {c, d}), do: a * c + b * d

  def sum({a, b}, {c, d}), do: {a + c, b + d}

  def subtract(a, b), do: b |> flip |> sum(a)

  # TODO rename ? `unit_vector`?
  def normalize({a, b} = vector) do
    magnitude = magnitude vector
    (for var <- [a, b], do: var / magnitude)
    |> List.to_tuple
  end

end
