defmodule Chukinas.Geometry.Pose do

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :angle, number()
  end

  # *** *******************************
  # *** NEW

  def new(x, y, angle) do
    %__MODULE__{
      x: x,
      y: y,
      angle: angle,
    }
  end

end
