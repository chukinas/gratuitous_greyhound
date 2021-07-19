defmodule Chukinas.LinearAlgebra do

  use Chukinas.Math
  use Chukinas.PositionOrientationSize
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
      import Chukinas.LinearAlgebra.CsysApi
      import Chukinas.LinearAlgebra.VectorApi
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

  defguard has_csys(csys)
    when is_map_key(csys, :orientation)
    and is_map_key(csys, :location)

  defguard is_coord(vec) when Guards.is_vector(vec)

  defguard is_vector(vec) when Guards.is_vector(vec)

  # *** *******************************
  # *** MERGE

  def merge_csys(map, csys_map), do: Maps.merge(map, csys_map, Csys)

  def merge_csys!(map, csys_map), do: Maps.merge!(map, csys_map, Csys)

  # *** *******************************
  # *** POS

  defdelegate pose_from_csys(csys), to: Csys, as: :pose

  def position_from_coord(coord), do: position_new(coord)

  # *** *******************************
  # *** CSYS

  def csys_from_vector(vector) when is_vector(vector) do
    Csys.new %{
      orientation: VectorApi.vector_from_angle(0),
      location: vector
    }
  end

  @spec csys_new(any) :: Csys.t
  defdelegate csys_new(pose_or_csys), to: Csys, as: :new
  def csys_new(x, y, angle), do: pose_new(x, y, angle) |> csys_new

  def csys_from_orientation_and_coord(orientation, coord) do
    Csys.new(orientation, coord)
  end

  defdelegate csys_forward(csys, distance), to: Csys, as: :forward

  def csys_left(csys), do: Csys.rotate(csys, -90)

  def csys_right(csys), do: Csys.rotate(csys, 90)

  def csys_90(csys, signed_number), do: Csys.rotate_90(csys, signed_number)

  def csys_180(csys), do: Csys.rotate(csys, 180)

  def csys_rotate(csys, angle), do: Csys.rotate(csys, angle)

  defdelegate csys_invert(csys), to: Csys, as: :invert

  # *** *******************************
  # *** CSYS -> VECTOR

  def coord_from_csys(csys), do: position_vector_from_csys(csys)

  # replace this with the above *from* functino?
  def coord_of_csys(csys), do: position_vector_from_csys(csys)

  def position_vector_from_csys(csys), do: Csys.location(csys)

  def angle_from_csys_orientation(csys) do
    csys |> Csys.orientation |> Vector.angle
  end

  # *** *******************************
  # *** POSE -> VECTOR

  # TODO rename these e.g. position_vector_forward?
  def vector_forward(pose_or_csys, distance) do
    pose_or_csys
    |> csys_new
    |> csys_forward(distance)
    |> position_vector_from_csys
  end

  def vector_left(pose_or_csys, distance) do
    pose_or_csys
    |> csys_new
    |> csys_left
    |> vector_forward(distance)
  end

  def vector_right(pose_or_csys, distance) do
    pose_or_csys
    |> csys_new
    |> csys_right
    |> vector_forward(distance)
  end

  def vector_90(pose_or_csys, distance, angle) do
    func = case normalize_angle(angle) do
      angle when angle < 180 -> &vector_right/2
      angle when angle > 180 -> &vector_left/2
    end
    func.(pose_or_csys, distance)
  end

  @spec vector_wrt_csys(Vector.t, Csys.t) :: Vector.t
  def vector_wrt_csys(vector, csys) do
    csys
    |> csys_invert
    |> Csys.transform_vector(vector)
  end

  def angle_of_coord_wrt_csys(coord, csys) do
    Angle.of_coord_wrt_csys(coord, csys)
  end

  def vector_from_csys_and_polar(csys, angle, radius) do
    csys
    |> csys_rotate(angle)
    |> csys_forward(radius)
    |> coord_of_csys
  end

  # *** *******************************
  # *** ANGLE

  def angle_from_vector(vector) do
    Angle.from_vector(vector, {1, 0})
  end

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

  # TODO replace with simply `csys_new`
  defp coerce_to_csys(pose) when has_pose(pose) do
    CsysApi.csys_from_pose(pose)
  end
  defp coerce_to_csys(csys) when has_csys(csys) do
    csys_new(csys)
  end
  defp coerce_to_csys(vector) when is_vector(vector) do
    csys_from_vector vector
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
