defmodule Chukinas.LinearAlgebra.CsysApi do

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Vector.Guards
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.VectorApi
  alias Chukinas.LinearAlgebra.OrientationMatrix
  alias Chukinas.Math
  alias Chukinas.PositionOrientationSize, as: POS

  # *** *******************************
  # *** CONSTRUCTORS

  def csys_from_angle(angle) when is_number(angle) do
    csys_new(0, 0, angle)
  end

  def csys_from_coord(vector) when is_vector(vector) do
    Csys.new(
      OrientationMatrix.from_angle(0),
      vector
    )
  end

  def csys_from_coord_and_angle(vector, angle)
  when is_vector(vector)
  and is_number(angle) do
    Csys.new(
      OrientationMatrix.from_angle(angle),
      vector
    )
  end

  def csys_from_orientation_and_coord(orientation, coord) do
    # TODO swap the 2 params
    Csys.new(orientation, coord)
  end

  def csys_from_pose(pose) when has_pose(pose) do
    Csys.new(
      pose |> POS.get_angle |> OrientationMatrix.from_angle,
      pose |> VectorApi.vector_from_position
    )
  end

  def csys_from_position(position) when has_position(position) do
    position
    |> pose_from_position
    |> csys_from_pose
  end

  def csys_from_map(csys), do: Csys.from_map(csys)

  def csys_new(x, y, angle \\ 0) do
    csys_from_coord_and_angle({x, y}, angle)
  end

  def csys_origin, do: csys_new(0, 0, 0)

  # *** *******************************
  # *** REDUCERS

  def csys_invert(csys), do: Csys.invert(csys)
  #defdelegate csys_invert(csys), to: Csys, as: :invert

  def csys_rotate(csys, :left), do: Csys.rotate(csys, -90)

  def csys_rotate(csys, :right), do: Csys.rotate(csys, 90)

  def csys_rotate(csys, :flip), do: Csys.rotate(csys, 180)

  def csys_rotate(csys, {:right_angle, sign}) when is_number(sign) do
    angle =
      sign
      |> Math.sign
      |> Math.mult(90)
    Csys.rotate(csys, angle)
  end

  def csys_rotate(csys, angle) when is_number(angle), do: Csys.rotate(csys, angle)

  # TODO needed?
  def csys_translate(csys, {:forward, distance}), do: Csys.forward(csys, distance)

  def csys_translate(csys, vector) when is_vector(vector) do
    Csys.translate(csys, vector)
  end

  def csys_translate_forward(csys, distance), do: Csys.forward(csys, distance)

  # *** *******************************
  # *** CONVERTERS

  def csys_to_pose(csys) do
    Csys.pose(csys)
  end

  def csys_to_coord_vector(csys), do: Csys.coord(csys)

  def csys_to_orientation_angle(csys), do: Csys.angle(csys)

end
