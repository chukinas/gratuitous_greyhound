defmodule SunsCore.Event.MovementStep.Move do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Ship.Move, as: ShipMove

  # *** *******************************
  # *** TYPES

  event_struct do
    field :moves, [ShipMove.t], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new([ShipMove.t]) :: t
  def new(moves) do
    %__MODULE__{
      moves: moves
    }
  end

  # *** *******************************
  # *** CONVERTERS

  # *** *******************************
  # *** CALLBACKS

end
