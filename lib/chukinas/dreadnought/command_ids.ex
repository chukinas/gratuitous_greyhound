defmodule Chukinas.Dreadnought.CommandIds do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :unit, integer()
    field :card, integer()
    field :segment, integer()
  end

  # *** *******************************
  # *** NEW

  def new(unit_id, card_id, segment_id) do
    %__MODULE__{
      unit: unit_id,
      card: card_id,
      segment: segment_id
    }
  end

  # *** *******************************
  # *** GETTERS

  def unit(%__MODULE__{unit: unit}), do: unit
  def card(%__MODULE__{card: card}), do: card
  def segment(%__MODULE__{segment: segment}), do: segment
end
