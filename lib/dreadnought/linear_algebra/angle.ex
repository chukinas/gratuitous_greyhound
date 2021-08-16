defmodule Dreadnought.LinearAlgebra.Angle do

  alias Dreadnought.LinearAlgebra.Csys
  alias Dreadnought.LinearAlgebra.Vector
  alias Dreadnought.LinearAlgebra.VectorApi
  alias Dreadnought.Math

  # TODO add guards (which need new source file)
  def from_vector(to_vector, from_vector) do
    abs_angle =
      from_vector
      |> between_vectors(to_vector)
    sign =
      from_vector
      |> VectorApi.vector_rotate(90)
      |> Vector.dot(to_vector)
      |> Math.sign
    Math.normalize_angle(abs_angle * sign)
  end

  def between_vectors(vector_a, vector_b) do
    [a, b] = for vec <- [vector_a, vector_b], do: Vector.normalize(vec)
    Vector.dot(a, b)
    |> Math.acos
    |> Math.normalize_angle
  end

  def of_coord_wrt_csys(coord, csys) do
    relative_vector =
      coord
      |> Vector.subtract(csys |> Csys.location)
    from_vector(relative_vector, csys |> Csys.orientation)
  end

end
