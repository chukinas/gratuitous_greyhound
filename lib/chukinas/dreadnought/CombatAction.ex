alias Chukinas.Dreadnought.{Unit, CombatAction, Turret, Gunfire}
alias Chukinas.Util.IdList
alias Chukinas.LinearAlgebra.{Vector, CSys}

defmodule CombatAction do

  alias CombatAction.Accumulator, as: Acc

  def exec(%{value: :noop}, %{units: units}), do: units
  def exec(
    %{unit_id: attacker_id, value: target_id} = _unit_action,
    %{units: units, turn_number: turn_number, gunfire: gunfire} = _mission
  ) do
    attacker = IdList.fetch!(units, attacker_id)
    target = IdList.fetch!(units, target_id)
    acc = Acc.new(attacker, target, turn_number, gunfire)
    {attacker, target, gunfire} =
      attacker
      |> Unit.all_turret_mount_ids
      |> Enum.reduce(acc, &maybe_fire_turret/2)
      |> Acc.to_tuple
    {IdList.put(units, [attacker, target]), gunfire}
  end

  defp maybe_fire_turret(turret_id, %Acc{} = acc) do
    with(
      {:ok, angle} <- turret_angle(acc, turret_id),
      {:ok, _reason} <- in_range?(angle),
      {:ok, _reason} <- has_los?(angle)
    ) do
      fire_turret(acc, turret_id, angle)
    else
      {:error, _reason} -> acc
    end
  end

  # TODO placeholders
  defp in_range?(_angle), do: {:ok, :in_range}
  defp has_los?(_angle), do: {:ok, :in_los}

  defp turret_angle(%Acc{} = acc, turret_id) do
    turret = Acc.turret(acc, turret_id)
    attacker = Acc.attacker(acc)
    desired_angle =
      acc
      |> Acc.target
      |> Unit.gunnery_target_vector
      |> CSys.Conversion.convert_from_world_vector(attacker, Turret.position_csys(turret))
      |> Vector.angle
    case Turret.normalize_desired_angle(turret, desired_angle) do
      {:ok, angle} -> {:ok, angle}
      {_, _angle} -> {:error, :not_in_arc}
    end
  end

  defp fire_turret(%Acc{} = acc, turret_id, angle) do
    attacker =
      acc
      |> Acc.attacker
      |> Unit.rotate_turret(turret_id, angle)
    turn_number = Acc.turn_number(acc)
    target =
      acc
      |> Acc.target
      |> Unit.put_damage(10, turn_number)
    gunfire = Gunfire.new(attacker, turret_id)
    Acc.put(acc, attacker, target, gunfire)
  end
end
