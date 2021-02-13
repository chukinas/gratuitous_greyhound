alias Chukinas.Dreadnought.{MoveSegment}
alias Chukinas.Geometry.Point

defmodule MoveSegment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :position, Point.t()
    field :svg_path, String.t()
    field :svg_viewbox, String.t()
  end
end
