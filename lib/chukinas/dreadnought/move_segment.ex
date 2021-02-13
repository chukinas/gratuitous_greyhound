alias Chukinas.Dreadnought.{MoveSegment}

defmodule MoveSegment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :element_position, String.t()
    field :svg_path, String.t()
    field :svg_viewbox, String.t()
  end
end
