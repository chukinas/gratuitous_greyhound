defmodule Chukinas.LinearAlgebra.VectorApi do

  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.LinearAlgebra.OrientationMatrix
  alias Chukinas.PositionOrientationSize, as: POS

  # *** *******************************
  # *** CONSTRUCTORS

  def vector_from_angle(angle), do: Vector.from_angle(angle)

  def vector_from_position(position), do: POS.position_to_tuple(position)

  def vector_origin, do: Vector.new(0, 0)

  def vector_new(x, y), do: Vector.new(x, y)

  # *** *******************************
  # *** REDUCERS

  def vector_add(a, b), do: Vector.sum(a, b)

  def vector_subtract(a, b), do: Vector.subtract(a, b)

  def vector_to_unit_vector(vector), do: Vector.normalize(vector)

  def vector_rotate(vector, angle) do
    angle
    |> OrientationMatrix.from_angle
    |> OrientationMatrix.to_rotated_vector(vector)
  end

  # *** *******************************
  # *** CONVERTERS

  def vector_to_magnitude(vector), do: Vector.magnitude(vector)

end
