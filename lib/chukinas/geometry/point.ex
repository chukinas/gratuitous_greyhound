defmodule Chukinas.Geometry.Point do

  # *** *******************************
  # *** TYPE

  use TypedStruct

  typedstruct enforce: true do
    field :x, number(), default: 0
    field :y, number(), default: 0
  end

  # *** *******************************
  # *** NEW

  def new(%{x: x, y: y}), do: new(x, y)
  def new(x, y) do
    %__MODULE__{x: x, y: y}
  end

  # *** *******************************
  # *** API

  def origin() do
    %__MODULE__{x: 0, y: 0}
  end

end
