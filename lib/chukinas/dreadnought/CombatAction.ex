alias Chukinas.Dreadnought.{Unit, CombatAction}
alias Chukinas.Util.ById

defmodule CombatAction do

  def exec(%{value: :noop}, %{units: units}), do: units
  def exec(%{unit_id: unit_id, value: target_id}, %{units: units, turn_number: turn_number}) do
    #actor =
    #  ById.get!(units, unit_id)
    #  |>
    target =
      ById.get!(units, target_id)
      |> Unit.put_damage(10, turn_number)
    #target_pos_wrt_actor_mount =
    #  actor
    ById.put(units, target)
  end
end
