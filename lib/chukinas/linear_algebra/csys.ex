defmodule Chukinas.LinearAlgebra.Csys do

  require Chukinas.PositionOrientationSize.Guards
  use TypedStruct
  use Chukinas.LinearAlgebra
  alias Chukinas.LinearAlgebra.Vector
  alias Chukinas.PositionOrientationSize, as: POS
  alias Chukinas.LinearAlgebra.OrientationMatrix
  alias Chukinas.LinearAlgebra.VectorApi

  # *** *******************************
  # *** TYPES

  @type orientation :: Vector.t
  @type location :: Vector.t

  typedstruct enforce: true do
    field :orientation, Vector.t
    field :location, Vector.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_map(%__MODULE__{} = csys), do: csys

  def from_map(%{orientation: orient, location: coord}), do: new(orient, coord)

  @spec new(orientation, location) :: t
  def new(orientation, location) when is_vector(location) do
    %__MODULE__{
      # TODO need unit vector
      orientation: orientation |> VectorApi.vector_to_unit_vector,
      location: location
    }
  end

  # *** *******************************
  # *** REDUCERS

  def forward(csys, distance) do
    location = location_after_moving_fwd(csys, distance)
    %__MODULE__{csys | location: location}
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
      |> OrientationMatrix.to_rotated_vector(intermediate_vector)
    new(orientation, position)
  end

  def location_after_moving_fwd(csys, distance) do
    location = csys |> location
    csys
    |> orientation
    |> Vector.scalar(distance)
    |> Vector.sum(location)
  end

  def put_coord(csys, coord) do
    Map.put(csys, :location, coord)
  end

  def rotate(csys, angle) do
    Map.update!(csys, :orientation, &VectorApi.vector_rotate(&1, angle))
  end

  def translate(csys, vector) do
    new_coord = transform_vector(csys, vector)
    put_coord(csys, new_coord)
  end

  # *** *******************************
  # *** CONVERTERS

  def angle(csys) do
    csys
    |> orientation_matrix
    |> OrientationMatrix.angle
  end

  def orientation_matrix(%{orientation: value}), do: value

  # TODO deprecate
  def orientation(csys), do: orientation_matrix(csys)

  def location(%{location: value}), do: value

  def coord(csys), do: coord_vector(csys)

  def coord_vector(%{location: value}), do: value

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

  def transform_vector(%__MODULE__{} = csys, vector)
  when is_vector(vector) do
    coord_vector =
      csys
      |> orientation
      |> OrientationMatrix.to_rotated_vector(vector)
    csys
    |> coord_vector
    |> VectorApi.vector_add(coord_vector)
  end

end
