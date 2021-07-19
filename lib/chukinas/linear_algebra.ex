defmodule Chukinas.LinearAlgebra do

  # TODO don't use `use`
  use Chukinas.Math
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Csys.Guards
  alias Chukinas.PositionOrientationSize, as: POS
  alias Chukinas.LinearAlgebra.Angle
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.LinearAlgebra.Vector.Guards
  alias Chukinas.LinearAlgebra.VectorApi
  alias Chukinas.LinearAlgebra.TransformApi
  alias Chukinas.Util.Maps
  require Guards

  # *** *******************************
  # *** TYPES

  @type coord :: POS.position_map | Vector.t
  @type pose_or_csys :: POS.pose_map | Csys.t
  @type pose_or_csys_s :: [pose_or_csys]

  # *** *******************************
  # *** USING

  defmacro __using__(_opts) do
    quote do
      require Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra.VectorApi
      import Chukinas.LinearAlgebra.CsysApi
      import Chukinas.LinearAlgebra.TransformApi
      use Chukinas.LinearAlgebra.Csys.Guards
      use Chukinas.LinearAlgebra.Vector.Guards
    end
  end


  # *** *******************************
  # *** MACROS

  use TypedStruct

  defmacro csys_fields do
    quote do
      field :orientation, Vector.t, enforce: true
      field :location, Vector.t, enforce: true
    end
  end

  # *** *******************************
  # *** MERGE

  def merge_csys(map, csys_map), do: Maps.merge(map, csys_map, Csys)

  # *** *******************************
  # *** ANGLE

  def angle_relative_to_vector(to_vector, from_vector) do
    Angle.from_vector(to_vector, from_vector)
  end

  def angle_between_vectors(a, b), do: Angle.between_vectors(a, b)

  # *** *******************************
  # *** RELATIVE POSITION TRANSLATIONS

  # TODO I don't like how this end-use pose functions are split b/w this and POS.ex

  def position_translate_right(poseable, distance) do
    position_translate(poseable, 0, distance)
  end

  def position_translate(poseable, x_rel, y_rel) do
    position_translate(poseable, {x_rel, y_rel})
  end

  def position_translate(poseable, {_x_rel, _y_rel} = rel_position) do
    rel_position
    |> TransformApi.vector_wrt_outer_observer(poseable)
    |> VectorApi.vector_to_position
  end

end
