defmodule Chukinas.LinearAlgebra.TransformApi do

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Csys.Guards
  use Chukinas.LinearAlgebra.Vector.Guards
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.CsysApi

  # *** *******************************
  # *** REDUCERS

  def vector_wrt_inner_observer(vector, observer) when is_vector(vector) do
    do_vector_wrt(vector, observer, :wrt_inner)
  end

  def vector_wrt_outer_observer(vector, observer) when is_vector(vector) do
    do_vector_wrt(vector, observer, :wrt_outer)
  end

  # *** *******************************
  # *** REDUCERS (PRIVATE)

  @type direction :: :wrt_inner | :wrt_outer
  @spec do_vector_wrt(any, any, direction) :: any

  defp do_vector_wrt(vector, [], _), do: vector

  defp do_vector_wrt(vector, [first_observer | others], direction) do
    vector
    |> do_vector_wrt(first_observer, direction)
    |> do_vector_wrt(others, direction)
  end

  defp do_vector_wrt(vector, observer, direction) when has_pose(observer) do
    do_vector_wrt(vector, CsysApi.csys_from_pose(observer), direction)
  end

  defp do_vector_wrt(vector, observer, direction) when has_position(observer) do
    do_vector_wrt(vector, CsysApi.csys_from_position(observer), direction)
  end

  defp do_vector_wrt(vector, observer, direction) when is_vector(observer) do
    do_vector_wrt(vector, CsysApi.csys_from_coord(observer), direction)
  end

  defp do_vector_wrt(vector, observer, direction) when is_csys(observer) do
    observer = case direction do
      :wrt_outer -> observer
      :wrt_inner -> CsysApi.csys_invert(observer)
    end
    Csys.transform_vector(observer, vector)
  end

end
