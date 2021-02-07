defmodule Chukinas.Dreadnought.Viewbox do
  alias Chukinas.Dreadnought.Vector
  alias Chukinas.Dreadnought.Svg

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :min_x, number(), default: 0
    field :min_y, number(), default: 0
    field :width, number()
    field :height, number()
  end

  # *** *******************************
  # *** NEW

  def from_line(vector_end, margin) do
    %__MODULE__{
      min_x: elem(vector_end.point, 0),
      min_y: elem(vector_end.point, 1),
      width: 100,
      height: 100,
    }
  end

  # *** *******************************
  # *** API

end
