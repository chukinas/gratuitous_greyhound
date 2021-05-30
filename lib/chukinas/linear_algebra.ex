alias Chukinas.LinearAlgebra
alias Chukinas.LinearAlgebra.Vector
alias Chukinas.LinearAlgebra.VectorCsys, as: Csys
alias Chukinas.Geometry.Trig
alias Chukinas.Util.Maps

defmodule LinearAlgebra do

  use Chukinas.PositionOrientationSize
  alias Vector.Guards
  require Guards


  # *** *******************************
  # *** USING

  defmacro __using__(_opts) do
    # TODO do something with opts
    quote do
      require Chukinas.LinearAlgebra
      import Chukinas.LinearAlgebra
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

  defguard is_vector(vec) when Guards.is_vector(vec)

  # *** *******************************
  # *** MERGE

  def merge_csys(map, csys_map), do: Maps.merge(map, csys_map, Csys)

  def merge_csys!(map, csys_map), do: Maps.merge!(map, csys_map, Csys)

  # *** *******************************
  # *** CSYS

  def csys_from_pose(pose), do: Csys.new(pose)

  defdelegate csys_new(pose_or_csys), to: Csys, as: :new
  def csys_new(x, y, angle), do: pose_new(x, y, angle) |> csys_new

  defdelegate csys_forward(csys, distance), to: Csys, as: :forward

  def csys_left(csys), do: Csys.rotate(csys, -90)

  def csys_right(csys), do: Csys.rotate(csys, 90)

  def csys_180(csys), do: Csys.rotate(csys, 180)

  def csys_rotate(csys, angle), do: Csys.rotate(csys, angle)

  defdelegate csys_invert(csys), to: Csys, as: :invert

  # *** *******************************
  # *** CSYS -> VECTOR

  def coord_of_csys(csys), do: position_vector_from_csys(csys)

  def position_vector_from_csys(csys), do: Csys.location(csys)

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
    func = case Trig.normalize_angle(angle) do
      angle when angle < 180 -> &vector_right/2
      angle when angle > 180 -> &vector_left/2
    end
    func.(pose_or_csys, distance)
  end

  def vector_wrt_csys(vector, csys) do
    csys
    |> csys_invert
    |> Csys.transform_vector(vector)
  end

  def vector_from_position(position), do: position_to_tuple(position)

  def angle_of_vector_wrt_csys(vector, csys) do
    csys
    |> Csys.orientation
    |> Vector.angle_between(vector)
  end

  def vector_from_csys_and_polar(csys, angle, radius) do
    csys
    |> csys_rotate(angle)
    |> csys_forward(radius)
    |> coord_of_csys
  end

  # *** *******************************
  # *** ???

  #def vector_right(item, distance) when has_pose(item) do
  #  convert_to_world_vector({0, +distance}, item)
  #end

  #def vector_angle(item, distance, angle) when has_pose(item) do
  #  item
  #  |> orientation_rotate(angle)
  #  |> vector_forward(distance)
  #end

  defdelegate vector_add(a, b), to: Vector, as: :add

  #def relative_vector_left(item, distance) do
  #  item |> put_zero_position |> vector_left(distance)
  #end

  #def relative_vector_right(item, distance) do
  #  item |> put_zero_position |> vector_right(distance)
  #end

  #def relative_vector_angle(item, distance, angle) do
  #  item |> put_zero_position |> vector_angle(distance, angle)
  #end

  #def relative_vector_right_angle(item, distance, angle) do
  #  item |> put_zero_position |> vector_right_angle(distance, angle)
  #end

  #def vector_from_position(item) do
  #  position_to_tuple(item)
  #end

end
