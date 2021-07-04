defmodule Chukinas.Dreadnought.ActionSelection.Maneuver do

  use Chukinas.PositionOrientationSize
  alias Chukinas.Geometry.GridSquare

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :unit_id, integer
    field :maneuver_selection_squares, [GridSquare.t], default: []
  end

  # *** *******************************
  # *** NEW

  def new(unit_id, squares) do
    %__MODULE__{
      unit_id: unit_id,
      maneuver_selection_squares: squares
    }
  end

end
