alias Chukinas.LinearAlgebra.{Vector, CSys, HasCsys}

# TODO rename Csys
defmodule CSys.Conversion do
  import Vector.Guards

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
    |> HasCsys.get_csys
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
    transform =
      item_with_csys
      |> HasCsys.get_csys
      |> CSys.flip
    Map.update!(token, :__transforms__, & [transform | &1])
  end

  def put(%__MODULE__{} = token, item_with_csys) do
    transform =
      item_with_csys
      |> HasCsys.get_csys
    Map.update!(token, :__transforms__, & [transform | &1])
  end

  def put_position(%__MODULE__{} = token, item_with_csys) do
    transform =
      item_with_csys
      |> HasCsys.get_csys
    Map.update!(token, :__transforms__, & [transform | &1])
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
    |> Enum.map(&HasCsys.get_angle/1)
    |> Enum.sum
  end
end
