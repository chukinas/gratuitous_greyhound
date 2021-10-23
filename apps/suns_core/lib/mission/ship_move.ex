defmodule SunsCore.Mission.Ship.Move do

  alias SunsCore.Space

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :ship_id, pos_integer
    field :position, Space.position
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(ship_id, position) do
    %__MODULE__{
      ship_id: ship_id,
      position: position
    }
  end

  # *** *******************************
  # *** CONVERTERS

  # *** *******************************
  # *** REDUCERS

end
