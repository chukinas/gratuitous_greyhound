alias Chukinas.Geometry, as: G

defmodule G.Polar do

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
    x = r * G.Trig.cos(angle)
    y = r * G.Trig.sin(angle)
    G.Point.new(x, y)
  end

end
