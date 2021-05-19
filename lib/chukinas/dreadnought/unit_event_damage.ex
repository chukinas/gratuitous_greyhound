alias Chukinas.Dreadnought.{Unit}

defmodule Unit.Event.Damage do
  @moduledoc """
  Describes a unit taking damage
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    #field :delay, number()
    #field :duration, number()
    field :turn, integer()
    field :amount, number()
  end

  # *** *******************************
  # *** NEW

  def new(turn, amount) do
    %__MODULE__{
      turn: turn,
      amount: amount
    }
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Unit.Event do
    def event?(_event), do: true
    def delay_and_duration(_), do: nil
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
