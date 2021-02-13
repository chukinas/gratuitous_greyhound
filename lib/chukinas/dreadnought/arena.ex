alias Chukinas.Geometry.{Point}

defmodule Chukinas.Dreadnought.Arena do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :size, Point.t()
  end

  # *** *******************************
  # *** NEW

  def new(size_x, size_y) do
    size = Point.new(size_x, size_y)
    %__MODULE__{size: size}
  end

end
