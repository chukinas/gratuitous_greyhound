defmodule Statechart do
  @moduledoc """
  Provides functions for pure manipulation of `Statechart` state machines.

  Build a state machine by using `Statechart.CreateMachine`.
  """

  alias Statechart.Machine

  defdelegate transition(machine, event), to: Machine

  defmacro __using__(:event) do
    quote do
      use Statechart.Event
    end
  end

  defmacro __using__(:machine) do
    quote do
      use Statechart.Machine.Builder
    end
  end

end
