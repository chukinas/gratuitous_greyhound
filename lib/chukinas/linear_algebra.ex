defmodule Chukinas.LinearAlgebra do

  use Chukinas.Math
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra.Csys.Guards
  alias Chukinas.PositionOrientationSize, as: POS
  alias Chukinas.LinearAlgebra.Angle
  alias Chukinas.LinearAlgebra.Csys
  alias Chukinas.LinearAlgebra.CsysApi
  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.LinearAlgebra.Vector.Guards
  alias Chukinas.LinearAlgebra.VectorApi
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
    # TODO do something with opts
    quote do
      require Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra.VectorApi
      import Chukinas.LinearAlgebra.CsysApi
      import Chukinas.LinearAlgebra.TransformApi
      use Chukinas.LinearAlgebra.Csys.Guards
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

  defguard is_coord(vec) when Guards.is_vector(vec)

  defguard is_vector(vec) when Guards.is_vector(vec)

  # *** *******************************
  # *** MERGE

  def merge_csys(map, csys_map), do: Maps.merge(map, csys_map, Csys)

  def merge_csys!(map, csys_map), do: Maps.merge!(map, csys_map, Csys)

  # *** *******************************
  # *** ANGLE

  def angle_relative_to_vector(to_vector, from_vector) do
    Angle.from_vector(to_vector, from_vector)
  end

  def angle_between_vectors(a, b), do: Angle.between_vectors(a, b)

  # *** *******************************
  # *** HELPERS

  # TODO where do these belong?
  defp coerce_to_vector(position) when has_position(position) do
    VectorApi.vector_from_position(position)
  end
  defp coerce_to_vector(vector) when is_vector(vector) do
    vector
  end

  defp coerce_to_csys_list(list) when is_list(list) do
    for item <- list, do: coerce_to_csys(item)
  end
  defp coerce_to_csys_list(item) do
    [coerce_to_csys item]
  end

  defp coerce_to_csys(pose) when has_pose(pose) do
    CsysApi.csys_from_pose(pose)
  end
  defp coerce_to_csys(csys) when is_csys(csys) do
    CsysApi.csys_from_map(csys)
  end
  defp coerce_to_csys(vector) when is_vector(vector) do
    CsysApi.csys_from_coord(vector)
  end


  #@spec something() :: [Csys.t]
  #def something do
  #  poseable = %{
  #    x: 1,
  #    y: 2,
  #    angle: 0,
  #    somethsraino: "ntesrai"
  #  }
  #  vector_inner_to_outer({0, 0}, poseable)
  #  #coerce_to_csys_list(poseable)
  #end

  # *** *******************************
  # *** COORD RELATIVE TO OUTER CSYS

  @doc """
  Translate an inner coord (e.g. turret position wrt ship) to outer coord (e.g. turret wrt world)
  """
  @spec vector_inner_to_outer(coord, pose_or_csys_s) :: Vector.t
  def vector_inner_to_outer(coord, pose_or_csys) do
    a = coerce_to_vector(coord)
    b = coerce_to_csys_list(pose_or_csys)
    do_vector_transform_to_outer(a, b)
  end

  # TODO deprecate
  @spec vector_transform_from(coord, pose_or_csys_s) :: Vector.t
  def vector_transform_from(coord, from) do
    do_vector_transform_to_outer(
      coord |> coerce_to_vector,
      from  |> coerce_to_csys_list
    )
  end

  defp do_vector_transform_to_outer(vector, []) do
    vector
  end

  defp do_vector_transform_to_outer(vector, [csys | remaining_csys]) do
    csys
    |> Csys.transform_vector(vector)
    |> do_vector_transform_to_outer(remaining_csys)
  end

  # *** *******************************
  # *** COORD RELATIVE TO INNER CSYS

  @doc """
  Translate an outer coord (e.g. target wrt world) to inner coord (e.g. target wrt turret)
  """
  @spec vector_outer_to_inner(coord, pose_or_csys_s) :: Vector.t
  def vector_outer_to_inner(coord, pose_or_csys) do
    vector_transform_to(coord, pose_or_csys)
  end

  # TODO deprecate
  @spec vector_transform_to(coord, pose_or_csys_s) :: Vector.t
  def vector_transform_to(coord, from) do
    do_vector_transform_to_inner(
      coord |> coerce_to_vector,
      from  |> coerce_to_csys_list
    )
  end

  defp do_vector_transform_to_inner(vector, []) do
    vector
  end

  defp do_vector_transform_to_inner(vector, [csys | remaining_csys]) do
    csys
    |> Csys.invert
    |> Csys.transform_vector(vector)
    |> do_vector_transform_to_inner(remaining_csys)
  end

  # *** *******************************
  # *** IN-PlACE RELATIVE POSE TRANSLATIONS

  @spec update_position_translate_right!(p, number) :: p when p: POS.position_map
  def update_position_translate_right!(poseable, distance) do
    fun = &position_translate_right(&1, distance)
    update_position!(poseable, fun)
  end

  @spec update_position_translate!(p, Vector.t) :: p when p: POS.position_map
  def update_position_translate!(poseable, vector) do
    fun = &position_translate(&1, vector)
    update_position!(poseable, fun)
  end

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
    |> vector_inner_to_outer(poseable)
    |> position_from_vector
  end

end
