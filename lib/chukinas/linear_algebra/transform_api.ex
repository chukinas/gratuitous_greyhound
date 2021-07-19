defmodule Chukinas.LinearAlgebra.TransformApi do

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Csys.Guards
  use Chukinas.LinearAlgebra.Vector.Guards
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.CsysApi
  alias Chukinas.LinearAlgebra.VectorApi
  #alias Chukinas.LinearAlgebra.VectorApi
  #alias Chukinas.LinearAlgebra.OrientationMatrix
  #alias Chukinas.Math
  #alias Chukinas.PositionOrientationSize, as: POS

  # *** *******************************
  # *** CONSTRUCTORS

  # *** *******************************
  # *** REDUCERS

  def position_wrt(position, observer) when has_position(position) do
    position
    |> VectorApi.vector_from_position
    |> vector_wrt(observer)
    |> VectorApi.vector_to_position
  end

  def vector_wrt(vector, observer) when is_vector(vector) do
    do_vector_wrt(vector, observer)
  end

  def vector_angle_wrt(vector, observer) do
    vector
    |> vector_wrt(observer)
    |> VectorApi.vector_to_angle
  end

  # *** *******************************
  # *** REDUCERS (PRIVATE)

  def do_vector_wrt(vector, []), do: vector

  def do_vector_wrt(vector, [first_observer | others]) do
    vector
    |> do_vector_wrt(first_observer)
    |> do_vector_wrt(others)
  end

  def do_vector_wrt(vector, observer) when is_csys(observer) do
    observer
    |> CsysApi.csys_invert
    |> Csys.transform_vector(vector)
  end

  # *** *******************************
  # *** CONVERTERS

end
