alias Chukinas.LinearAlgebra.{Vector, Matrix}

defmodule Matrix.Guards do
  import Vector.Guards
  defguard is_matrix(value)
    when tuple_size(value) == 2
    and elem(value, 0) |> is_vector
    and elem(value, 1) |> is_vector
end

defmodule Matrix do
  @type t() :: {Vector.t(), Vector.t()}

  # *** *******************************
  # *** NEW

  def identity, do: {{1, 0}, {0, 1}}

  # *** *******************************
  # *** GETTERS

  def first_elem(matrix), do: elem(matrix, 1, 1)

  def elem(matrix, pos1, pos2) do
    matrix |> elem(pos1) |> elem(pos2)
  end

  # *** *******************************
  # *** API

  def flip({{a, b}, {c, d}}) do
    {{a, -b}, {-c, d}}
  end

  @spec mult(t(), Vector.t()) :: Vector.t()
  def mult({a, b}, c) do
    {Vector.dot(a, c), Vector.dot(b, c)}
  end
end
