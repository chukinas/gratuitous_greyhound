alias Chukinas.Dreadnought.{Unit}
alias Unit.Event.Damage

defmodule Damage do
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

  def new(amount, turn) do
    %__MODULE__{
      turn: turn,
      amount: amount
    }
  end

  # *** *******************************
  # *** GETTERS

  def amount(%__MODULE__{amount: damage}), do: damage

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Unit.Event do
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


defmodule Damage.Enum do
  def sum(events) do
    events
    |> Stream.map(&Damage.amount/1)
    |> Enum.sum
  end
end
