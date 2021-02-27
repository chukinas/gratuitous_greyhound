defmodule Chukinas.Dreadnought.Card do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    # ID only has to be unique within a deck
    field :id, integer(), enforce: true

    # Each card belongs to a deck which belongs to a unit
    field :unit_id, integer(), enforce: true

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

  @spec new(integer(), integer()) :: t()
  def new(id, unit_id) do
    %__MODULE__{
      id: id,
      unit_id: unit_id,
      speed: Enum.random(1..5),
      angle: -18..18 |> Enum.map(&(&1 * 5)) |> Enum.random()
    }
  end

end
