defmodule Dreadnought.Core.Unit.Event.Damage do
  @moduledoc """
  Describes a unit taking damage
  """
  alias Dreadnought.Core.Unit.Event, as: Ev

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    #field :duration, number()
    field :turn, integer()
    field :delay, number()
    field :amount, number()
  end

  # *** *******************************
  # *** NEW

  def new(amount, turn, delay) do
    %__MODULE__{
      turn: turn,
      delay: delay,
      amount: amount
    }
  end

  # *** *******************************
  # *** GETTERS

  def amount(%__MODULE__{amount: damage}), do: damage

  def turn_and_delay(%__MODULE__{} = event) do
    {event.turn, event.delay}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Ev do
    def event?(_event), do: true
    def delay_and_duration(_), do: nil
    def stashable?(_), do: true
  end

  defimpl Inspect do
    require IOP
    def inspect(event, opts) do
      title = "Event(Damage)"
      fields = [
        turn: event.turn,
        amount: event.amount
      ]
      IOP.struct(title, fields)
    end
  end

end
