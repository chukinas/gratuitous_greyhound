alias Dreadnought.Core.{Unit}
alias Unit.Status
alias Unit.Event, as: Ev

# TODO rename this Status and rename Status -> Status.Data
defmodule Status.Logic do

  # *** *******************************
  # *** FUNCTIONS

  def calc_status(unit) do
    status = case destroyed?(unit) do
      :no -> Status.new(true, true)
      :this_turn -> Status.new(true, false)
      :past_turn -> Status.new(false, false)
    end
    Unit.put(unit, status)
  end

  def destroyed?(unit) do
    cond do
      Unit.any_events?(unit, Ev.Destroyed, :past) ->
        :past_turn
      Unit.any_events?(unit, Ev.Destroyed, :current) ->
        :this_turn
      true ->
        :no
    end
  end
end
