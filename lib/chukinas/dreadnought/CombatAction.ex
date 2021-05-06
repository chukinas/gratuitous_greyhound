alias Chukinas.Dreadnought.{Unit, CombatAction, Turret}
alias Chukinas.Util.ById
alias Chukinas.LinearAlgebra.CSys

defmodule CombatAction do

  def exec(%{value: :noop}, %{units: units}), do: units
  def exec(
    %{unit_id: attacker_id, value: target_id} = _unit_action,
    %{units: units, turn_number: turn_number} = _mission
  ) do
    attacker = ById.get!(units, attacker_id)
    target = ById.get!(units, target_id)
    {attacker, target, _turn_number} =
      Unit.all_turret_mount_ids(attacker)
      |> Enum.reduce({attacker, target, turn_number}, &fire_turret/2)
    ById.put(units, [attacker, target])
  end

  defp fire_turret(turret_id, {attacker, target, turn_number} = _acc) do
    turret = Unit.turret(attacker, turret_id)
    desired_angle =
      Unit.gunnery_target_vector(target)
      |> CSys.Conversion.new
      |> CSys.Conversion.put_inv(attacker)
      |> CSys.Conversion.put_inv(turret)
      |> CSys.Conversion.get_angle
      |> IOP.inspect
    {angle, target} = case Turret.normalize_desired_angle(turret, desired_angle) do
      {:ok, angle} -> {angle, Unit.put_damage(target, 10, turn_number)}
      {_, angle} -> {angle, target}
    end
    IOP.inspect angle,  "actual angle"
    attacker = Unit.rotate_turret(attacker, turret_id, angle)
    {attacker, target, turn_number}
  end
end
