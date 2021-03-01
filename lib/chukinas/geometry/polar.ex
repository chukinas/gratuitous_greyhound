alias Chukinas.Geometry.{Polar, Position, Trig}

defmodule Polar do

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
    x = r * Trig.cos(angle)
    y = r * Trig.sin(angle)
    Position.new(x, y)
  end

end
