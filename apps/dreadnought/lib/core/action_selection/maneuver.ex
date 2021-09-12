defmodule Dreadnought.Core.ActionSelection.Maneuver do

    use Spatial.PositionOrientationSize
    use Spatial.TypedStruct
  alias Dreadnought.GridSquare

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :unit_id, integer
    field :squares, [GridSquare.t], default: []
    field :square_size, number
  end

  # *** *******************************
  # *** NEW

  def new(unit_id, [square | _] = squares) do
    %__MODULE__{
      unit_id: unit_id,
      squares: squares,
      square_size: GridSquare.size(square)
    }
  end

end
