defmodule Chukinas.LinearAlgebra.CsysApi do

  use Chukinas.PositionOrientationSize
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.VectorApi
  alias Chukinas.LinearAlgebra.OrientationMatrix
  alias Chukinas.PositionOrientationSize, as: POS

  # *** *******************************
  # *** CONSTRUCTORS

  def csys_origin do
    Csys.new(
      VectorApi.vector_origin(),
      VectorApi.vector_origin()
    )
  end

  def csys_from_pose(pose) when has_pose(pose) do
    Csys.new(
      pose |> POS.get_angle |> OrientationMatrix.from_angle,
      pose |> VectorApi.vector_from_position
    )
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

end
