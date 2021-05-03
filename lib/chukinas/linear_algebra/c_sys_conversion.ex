alias Chukinas.LinearAlgebra.{Transform, Vector, CSys}

defmodule CSys.Conversion do
  import Vector.Guards

  use TypedStruct
  typedstruct enforce: true do
    field :__transforms__, [Transform.t()], default: []
    field :__start_point__, Vector.t()
  end

  # *** *******************************
  # *** NEW

  def new(starting_point \\ {0, 0})
  def new(%Transform{} = starting_point) do
    %__MODULE__{__start_point__: starting_point |> Transform.position}
  end
  def new(starting_point) when is_vector(starting_point) do
    %__MODULE__{__start_point__: starting_point}
  end

  # *** *******************************
  # *** API

  def put_inv(%__MODULE__{} = token, %Transform{} = transform) do
    Map.update!(token, :__transforms__, & [Transform.flip(transform) | &1])
  end
  def put(%__MODULE__{} = token, %Transform{} = transform) do
    Map.update!(token, :__transforms__, & [transform | &1])
  end

  def exec(%__MODULE__{__transforms__: transforms, __start_point__: vector}) do
    transforms
    |> Enum.reverse
    |> Enum.reduce(vector, &Transform.transform/2)
  end
end
