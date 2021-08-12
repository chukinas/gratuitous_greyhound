alias Dreadnought.Core.{Unit}
alias Unit.Event, as: Ev

defmodule Ev.Destroyed do
  @moduledoc """
  Records the destruction of a unit
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :cause, :gunfire | :leaving
    field :turn, integer()
    field :delay, number()
  end

  # *** *******************************
  # *** NEW

  defp new(cause, turn, delay) do
    %__MODULE__{
      cause: cause,
      turn: turn,
      delay: delay
    }
  end

  def by_gunfire(turn_number, delay) do
    new(:gunfire, turn_number, delay)
  end

  def by_leaving_arena(turn_number) do
    new(:leaving, turn_number, 0)
  end

  def by_running_aground(turn_number, delay) do
    new(:aground, turn_number, delay)
  end

  # *** *******************************
  # *** GETTERS

  def get_fadeout(%__MODULE__{cause: cause, delay: delay}) do
    case cause do
      :leaving -> Ev.Fadeout.new(delay, 1)
      :gunfire -> Ev.Fadeout.new(delay, 0.4)
    end
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
      title = "Event(Destroyed)"
      fields = [
        cause: event.cause,
        turn: event.turn
      ]
      IOP.struct(title, fields)
    end
  end

end
