defmodule Chukinas.Dreadnought.Model.Card do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    # ID only has to be unique within a deck
    field :id, integer(), enforce: true

    # 1..5
    field :speed, integer(), default: 3

    # Angle of turn
    # 0 for straight maneuver
    # X  for right turn (e.g. 45)
    # -X for left turn (e.g. -45)
    field :angle, integer(), default: 0
  end

  # *** *******************************
  # *** NEW

  @spec new(integer()) :: t()
  def new(id) do
    %__MODULE__{
      id: id,
      speed: Enum.random(1..5),
      angle: Enum.random(-90..90)
    }
  end

end