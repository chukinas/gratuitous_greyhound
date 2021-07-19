defmodule Chukinas.LinearAlgebra.CsysApi do

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Vector.Guards
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.VectorApi
  alias Chukinas.LinearAlgebra.OrientationMatrix
  alias Chukinas.PositionOrientationSize, as: POS

  # *** *******************************
  # *** CONSTRUCTORS

  def csys_from_coord(vector) when is_vector(vector) do
    Csys.new(
      OrientationMatrix.from_angle(0),
      vector
    )
  end

  def csys_from_pose(pose) when has_pose(pose) do
    Csys.new(
      pose |> POS.get_angle |> OrientationMatrix.from_angle,
      pose |> VectorApi.vector_from_position
    )
  end

  def csys_origin do
    Csys.new(
      VectorApi.vector_origin(),
      VectorApi.vector_origin()
    )
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  def csys_to_pose(csys) do
    Csys.pose(csys)
  end

  def csys_to_coord_vector(csys), do: Csys.coord(csys)

  def csys_to_orientation_angle(csys), do: Csys.angle(csys)

end
