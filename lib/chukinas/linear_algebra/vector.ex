alias Chukinas.LinearAlgebra.{Vector}

defmodule Vector.Guards do
  defguard is_vector(value)
    when tuple_size(value) == 2
    and elem(value, 0) |> is_number
    and elem(value, 1) |> is_number
end

defmodule Vector do
  @type t() :: {number(), number()}
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
end
