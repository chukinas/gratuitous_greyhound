alias Chukinas.Dreadnought.{Unit, CombatAction}
alias Chukinas.Util.ById

defmodule CombatAction do

  def exec(%{value: :noop}, %{units: units}), do: units
  def exec(%{value: target_id}, %{units: units, turn_number: turn_number}) do
    target =
      ById.get!(units, target_id)
      |> Unit.put_damage(10, turn_number)
    ById.put(units, target)
  end
end
