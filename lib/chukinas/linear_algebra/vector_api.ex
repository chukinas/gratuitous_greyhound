defmodule Chukinas.LinearAlgebra.VectorApi do

  use Chukinas.Math
  use Chukinas.PositionOrientationSize
  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.LinearAlgebra.Vector.Guards
  require Guards

  # *** *******************************
  # *** CONSTRUCTORS

  def vector_from_angle(angle), do: Vector.from_angle(angle)

  # TODO alias instead of use
  def vector_from_position(position), do: position_to_tuple(position)

  def vector_origin, do: Vector.new(0, 0)

  def vector_new(x, y), do: Vector.new(x, y)

  # *** *******************************
  # *** REDUCERS

  def vector_add(a, b), do: Vector.sum(a, b)

  def vector_subtract(a, b), do: Vector.subtract(a, b)

  def vector_to_unit_vector(vector), do: Vector.normalize(vector)

  # *** *******************************
  # *** CONVERTERS

  def vector_to_magnitude(vector), do: Vector.magnitude(vector)

end
