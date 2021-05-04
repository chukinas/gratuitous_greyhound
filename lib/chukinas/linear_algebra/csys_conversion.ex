alias Chukinas.LinearAlgebra.{Vector, CSys}

# TODO rename Csys
defmodule CSys.Conversion do
  import Vector.Guards

  use TypedStruct
  typedstruct enforce: true do
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

  # *** *******************************
  # *** API

  def put_inv(%__MODULE__{} = token, %CSys{} = transform) do
    Map.update!(token, :__transforms__, & [CSys.flip(transform) | &1])
  end
  def put(%__MODULE__{} = token, %CSys{} = transform) do
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
end
