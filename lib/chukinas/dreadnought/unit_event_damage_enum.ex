alias Chukinas.Dreadnought.Unit.Event.Damage

defmodule Damage.Enum do

  def sum(events) do
    events
    |> Stream.map(&Damage.amount/1)
    |> Enum.sum
  end

  def has_remaining_health?(damage_events, starting_health) do
    remaining_health(damage_events, starting_health) > 0
  end

  def remaining_health(damage_events, starting_health) do
    (starting_health - sum(damage_events))
    |> max(0)
  end
end
