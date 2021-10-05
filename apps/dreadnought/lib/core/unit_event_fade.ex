alias Dreadnought.Core.{Unit}
alias Unit.Event, as: Ev

defmodule Ev.Fadeout do
  @moduledoc """
  Describes a unit fading from view, usually meaning that it's out of action
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :delay, number()
    field :duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(delay, duration) do
    %__MODULE__{
      delay: delay,
      duration: duration
    }
  end

  def entire_turn do
    new(0, 1)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Ev do
    def event?(_event), do: true
    def delay_and_duration(%{delay: delay, duration: duration}) do
      {delay, duration}
    end
    def stashable?(_), do: false
    #def duration(%{duration: duration}), do: duration
  end

  defimpl Inspect do
    require IOP
    def inspect(event, opts) do
      title = "Event(Fadeout)"
      fields = [
        time: {event.delay, event.duration},
      ]
      IOP.struct(title, fields)
    end
  end

end
