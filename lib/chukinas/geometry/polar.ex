defmodule Chukinas.Geometry.Polar do

  # *** *******************************
  # *** TYPE

  use TypedStruct

  typedstruct enforce: true do
    field :r, number(), default: 0
    field :angle, number(), default: 0
  end

  # *** *******************************
  # *** NEW

  def new(r, angle) do
    %__MODULE__{r: r, angle: angle}
  end

  # *** *******************************
  # *** API

  def to_cartesian(%__MODULE__{r: r, angle: angle}) do
    alias Chukinas.Geometry.Trig
    x = r * Trig.cos(angle)
    y = r * Trig.sin(angle)
    Chukinas.Geometry.Cartesian.new(x, y)
  end

end
