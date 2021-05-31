alias Chukinas.LinearAlgebra.{Vector}
alias Chukinas.Math

defmodule Chukinas.LinearAlgebra.VectorCsys do

  alias Chukinas.PositionOrientationSize, as: POS
  require POS.Guards
  import POS.Guards
  require Vector.Guards
  import Vector.Guards
  use TypedStruct

  typedstruct enforce: true do
    # TODO replace with csys_fields?
    field :orientation, Vector.t
    field :location, Vector.t
  end

  def new(%__MODULE__{} = csys), do: csys

  # TODO use guard has_csys
  def new(%{orientation: orient, location: loc}) do
    new(orient, loc)
  end

  def new(pose) when has_pose(pose) do
    new(
      _orientation = pose |> POS.get_angle |> Vector.from_angle,
      _location = pose |> POS.position_to_tuple
    )
  end

  def new(orientation, location)
  when is_vector(orientation)
  and is_vector(location) do
    %__MODULE__{
      # TODO need unit vector
      orientation: orientation,
      location: location
    }
  end

  def rotate(csys, angle) do
    Map.update!(csys, :orientation, &Vector.rotate(&1, angle))
  end

  def rotate_90(csys, direction) do
    rotate(csys, 90 * Math.sign(direction))
  end

  def forward(csys, distance) do
    IOP.inspect csys, "forward - csys"
    location = location_after_moving_fwd(csys, distance)
    %__MODULE__{csys | location: location}
  end

  def location_after_moving_fwd(csys, distance) do
    location = csys |> location
    csys
    |> orientation
    |> IOP.inspect("orientation")
    |> Vector.scalar(distance)
    |> IOP.inspect("travel vector")
    |> Vector.add(location)
  end

  def invert(csys) do
    orientation =
      csys
      |> orientation
      |> Vector.flip_sign_y
    intermediate_vector =
      csys
      |> location
      |> Vector.flip_sign
    position =
      orientation
      |> Vector.matrix_dot_vector(intermediate_vector)
    new(orientation, position)
  end

  # *** *******************************
  # *** GETTERS

  def orientation(%{orientation: value}), do: value

  def location(%{location: value}), do: value

  def pose(%{} = csys) do
    angle =
      csys
      |> orientation
      |> Vector.angle
    csys
    |> location
    |> POS.pose_new(angle)
  end

  def position(%{} = csys) do
    csys
    |> location
    |> POS.position_new
  end

  # *** *******************************
  # *** API

  def add_csys_location(vector, %__MODULE__{} = csys) do
    csys
    |> location
    |> Vector.add(vector)
  end

  def transform_vector(%__MODULE__{} = csys, vector)
  when is_vector(vector) do
    csys
    |> orientation
    |> Vector.matrix_dot_vector(vector)
    |> add_csys_location(csys)
  end

end
