alias Chukinas.Dreadnought.{Unit, CombatAction, Turret, Gunfire}
alias Chukinas.Util.IdList
alias Chukinas.LinearAlgebra.{Vector, CSys}

defmodule CombatAction do

  def exec(%{value: :noop}, %{units: units}), do: units
  def exec(
    %{unit_id: attacker_id, value: target_id} = _unit_action,
    %{units: units, turn_number: turn_number} = _mission
  ) do
    attacker = IdList.fetch!(units, attacker_id)
    target = IdList.fetch!(units, target_id)
    {attacker, target, _turn_number, gunfire} =
      Unit.all_turret_mount_ids(attacker)
      |> Enum.reduce({attacker, target, turn_number, []}, &fire_turret/2)
    {IdList.put(units, [attacker, target]), gunfire}
  end

  defp fire_turret(turret_id, {attacker, target, turn_number, gunfires} = _acc) do
    turret = Unit.turret(attacker, turret_id)
    desired_angle =
      Unit.gunnery_target_vector(target)
      |> CSys.Conversion.convert_from_world_vector(attacker, Turret.position_csys(turret))
      |> Vector.angle
    {angle, target} = case Turret.normalize_desired_angle(turret, desired_angle) do
      {:ok, angle} -> {angle, Unit.put_damage(target, 10, turn_number)}
      {_, angle} -> {angle, target}
    end
    attacker = Unit.rotate_turret(attacker, turret_id, angle)
    gunfire = Gunfire.new(attacker, turret_id)
    {attacker, target, turn_number, [gunfire | gunfires]}
  end
end
