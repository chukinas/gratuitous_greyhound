defmodule Spatial.LinearAlgebra.VectorApi do

    use Spatial.LinearAlgebra.Vector.Guards
  alias Spatial.LinearAlgebra.Vector
  alias Spatial.LinearAlgebra.OrientationMatrix
  alias Spatial.PositionOrientationSize, as: POS

  # *** *******************************
  # *** CONSTRUCTORS

  def vector_from_angle(angle), do: Vector.from_angle(angle)

  def vector_from_polar(radius, angle) do
    angle
    |> vector_from_angle
    |> Vector.scalar(radius)
  end

  def vector_from_position(position), do: POS.position_to_tuple(position)

  def vector_origin, do: Vector.new(0, 0)

  def vector_new(x, y), do: Vector.new(x, y)

  # *** *******************************
  # *** REDUCERS

  def vector_add(a, b), do: Vector.sum(a, b)

  def vector_add_x({x, y}, dx) do
    {x + dx, y}
  end

  def vector_add_y({x, y}, dy) do
    {x, y + dy}
  end

  def vector_multiply(vector, scalar) do
    Vector.scalar(vector, scalar)
  end

  def vector_rand_within(vector, radius) when is_number(radius) do
    1..360
    |> Enum.random
    |> vector_from_angle
    |> vector_multiply(radius)
    |> vector_add(vector)
  end

  def vector_rotate(vector, angle) do
    angle
    |> OrientationMatrix.from_angle
    |> OrientationMatrix.to_rotated_vector(vector)
  end

  def vector_subtract(a, b) when is_vector(b), do: Vector.subtract(a, b)
  def vector_subtract(a, b) when is_number(b), do: Vector.subtract(a, {b, b})

  def vector_to_unit_vector(vector), do: Vector.normalize(vector)

  def vector_round({x, y}) do
    {round(x), round(y)}
  end

  # *** *******************************
  # *** CONVERTERS

  def vector_to_angle(vector), do: Vector.angle(vector)

  def vector_to_magnitude(vector), do: Vector.magnitude(vector)

  def vector_to_position({x, y}), do: POS.position_new(x, y)

end
