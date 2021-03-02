defmodule Chukinas.Dreadnought.CommandIds do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :unit, integer()
    field :card, integer()
    field :step, integer()
  end

  # *** *******************************
  # *** NEW

  def new(unit_id, card_id, segment_id) do
    %__MODULE__{
      unit: unit_id,
      card: card_id,
      step: segment_id
    }
  end

  # *** *******************************
  # *** GETTERS

  def unit(%__MODULE__{unit: unit}), do: unit
  def card(%__MODULE__{card: card}), do: card
  def step(%__MODULE__{step: step}), do: step
end
