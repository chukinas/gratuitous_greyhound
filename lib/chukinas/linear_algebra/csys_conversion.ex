alias Chukinas.LinearAlgebra.{Vector, CSys, HasCsys}
alias Chukinas.Util.Maps

# TODO rename Csys
defmodule CSys.Conversion do

  import Vector.Guards
  alias Chukinas.PositionOrientationSize, as: POS
  require POS.Guards
  use TypedStruct

  typedstruct enforce: true do
    # TODO rename __rotation__ ?
    field :__transforms__, [CSys.t()], default: []
    field :__start_point__, Vector.t()
  end

  # *** *******************************
  # *** NEW

  def new(starting_point \\ {0, 0})
  def new(%CSys{} = starting_point) do
    %__MODULE__{__start_point__: starting_point |> CSys.position}
  end
  def new(starting_point) when is_vector(starting_point) do
    %__MODULE__{__start_point__: starting_point}
  end
  def new(starting_point) do
    starting_point
    |> get_csys
    |> new
  end

  # *** *******************************
  # *** API

  def convert_to_world_vector(vector, unit) do
    vector
    |> CSys.Conversion.new
    |> CSys.Conversion.put(unit)
    |> CSys.Conversion.get_vector
  end

  def convert_to_world_vector(vector, unit, mount) do
    vector
    |> CSys.Conversion.new
    |> CSys.Conversion.put(mount)
    |> CSys.Conversion.put(unit)
    |> CSys.Conversion.get_vector
  end

  def convert_from_world_vector(vector, unit) do
    vector
    |> CSys.Conversion.new
    |> CSys.Conversion.put_inv(unit)
    |> CSys.Conversion.get_vector
  end

  def convert_from_world_vector(vector, unit, mount) do
    vector
    |> CSys.Conversion.new
    |> CSys.Conversion.put_inv(mount)
    |> CSys.Conversion.put_inv(unit)
    |> CSys.Conversion.get_vector
  end

  def put_inv(%__MODULE__{} = token, item_with_csys) do
    item_with_csys
    |> get_csys
    |> CSys.flip
    |> push_transform_into(token)
  end

  def put(%__MODULE__{} = token, item_with_csys) do
    item_with_csys
    |> get_csys
    |> push_transform_into(token)
  end

  def put_position(%__MODULE__{} = token, item_with_csys) do
    item_with_csys
    |> get_csys
    |> push_transform_into(token)
  end

  def get_vector(%__MODULE__{__transforms__: transforms, __start_point__: vector}) do
    transforms
    |> Enum.reverse
    |> Enum.reduce(vector, &CSys.transform/2)
  end

  def get_angle(conversion) do
    conversion
    |> get_vector
    |> Vector.angle
  end

  def sum_angles(a, b), do: sum_angles([a, b])
  def sum_angles(items_with_csys) do
    items_with_csys
    |> Enum.map(&get_item_angle/1)
    |> Enum.sum
  end

  def push_transform_into(transform, token) do
    Maps.push(token, :__transforms__, transform)
  end

  # *** *******************************
  # *** fazing out HasCsys...

  def get_item_angle(item) when POS.Guards.has_pose(item), do: POS.get_angle(item)
  def get_item_angle(item), do: HasCsys.get_angle(item)

  def get_csys(item) when POS.Guards.has_pose(item), do: CSys.new(item)
  def get_csys(item), do: HasCsys.get_csys(item)

end
