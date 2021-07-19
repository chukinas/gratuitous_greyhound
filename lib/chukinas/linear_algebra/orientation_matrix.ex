defmodule Chukinas.LinearAlgebra.OrientationMatrix do
  @moduledoc"""
  Operate on unit vectors representing orientation

  Take any 2D vector and reduce it to a unit vector, {x, y}.
  If you think of this unit vector as the x-axis of a new coordinate system,
  then the y-axis is defined as the unit vector {-y, x}
  This coordinate system can be represented as the matrix

    ----- y-axis
    |
    |  -- y-axis
    |  |
    V  V

    x -y   <-- x-components
    y  x   <-- y-components

  The y-axis provides no new information, so the data structure for representing
  an orientation matrix is just a simple vector, Chukinas.LinearAlgebra.Vector.t
  """

  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.LinearAlgebra.Vector.Guards
  require Guards

  # *** *******************************
  # *** TYPES

  @type vector() :: {number(), number()}
  @type t() :: vector

  # *** *******************************
  # *** CONSTRUCTORS

  @spec from_angle(number) :: t
  def from_angle(angle) when is_number(angle) do
    Vector.from_angle(angle)
  end

  @spec from_vector(vector) :: t
  def from_vector(vector), do: Vector.normalize(vector)

  # *** *******************************
  # *** CONVERTERS

  @spec x_axis(t) :: vector
  def x_axis({x, y}), do: {x,  y}

  @spec y_axis(t) :: vector
  def y_axis({x, y}), do: {-y, x}

  @doc"""
  Return vector of same magnitude, but parallel to x-axis of orientation matrix
  """
  @spec to_rotated_vector(t, vector) :: vector
  def to_rotated_vector(matrix, vector) do
    for component <- [:x, :y] do
      matrix
      |> components(component)
      |> Vector.dot(vector)
    end
    |> List.to_tuple
  end

  # *** *******************************
  # *** CONVERTERS (PRIVATE)

  defp components({x, y}, :x), do: {x, -y}

  defp components({x, y}, :y), do: {y,  x}

end
