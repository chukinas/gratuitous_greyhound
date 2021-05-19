alias Chukinas.Dreadnought.{Unit, CombatAction, Turret, Animation}
alias Chukinas.Geometry.{Collide, Straight, Pose}
alias Chukinas.Util.IdList
alias Chukinas.LinearAlgebra.{Vector, CSys}

defmodule CombatAction do

  alias CombatAction.Accumulator, as: Acc

  # *** *******************************
  # *** API

  def exec(%{value: :noop}, %{units: units, gunfire: gunfire}), do: {units, gunfire}
  def exec(
    %{unit_id: attacker_id, value: target_id} = _unit_action,
    %{units: units, turn_number: turn_number, gunfire: gunfire, islands: islands} = _mission
  ) do
    attacker = IdList.fetch!(units, attacker_id)
    target = IdList.fetch!(units, target_id)
    acc = Acc.new(attacker, target, turn_number, gunfire, islands)
    {attacker, target, gunfire} =
      attacker
      |> Unit.all_turret_mount_ids
      |> Enum.reduce(acc, &maybe_fire_turret/2)
      |> Acc.to_tuple
    {IdList.put(units, [attacker, target]), gunfire}
  end

  defp maybe_fire_turret(turret_id, %Acc{} = acc) do
    with(
      {:ok, target_vector} <- target_vector(acc),
      {:ok, turret_angle } <- turret_angle(acc, target_vector, turret_id),
      {:ok, path         } <- path_to_target(acc, target_vector, turret_id),
      {:ok, range        } <- range_to_target(path)
    ) do
      fire_turret(acc, turret_id, turret_angle, range, path)
    else
      {:fail, _reason} -> move_turret_to_neutral(acc, turret_id)
    end
  end

  defp target_vector(%Acc{} = acc) do
    vector =
      acc
      |> Acc.target
      |> Unit.gunnery_target_vector
    {:ok, vector}
  end

  defp turret_angle(%Acc{} = acc, target_vector, turret_id) do
    turret = Acc.turret(acc, turret_id)
    attacker = Acc.attacker(acc)
    desired_angle =
      target_vector
      |> CSys.Conversion.convert_from_world_vector(attacker, Turret.position_csys(turret))
      |> Vector.angle
    case Turret.normalize_desired_angle(turret, desired_angle) do
      {:ok, angle} -> {:ok, angle}
      {_, _angle} -> {:fail, :out_of_fire_arc}
    end
  end

  defp path_to_target(%Acc{} = acc, target_vector, turret_id) do
    turret = Acc.turret(acc, turret_id)
    attacker = Acc.attacker(acc)
    turret_vector = CSys.Conversion.convert_to_world_vector(turret, attacker)
    path_vector = Vector.subtract(target_vector, turret_vector)
    angle = Vector.angle(path_vector)
    path_start_pose = Pose.new(turret_vector, angle)
    range = Vector.magnitude(path_vector)
    path = Straight.new(path_start_pose, range)
    if Collide.avoids?(path, Acc.islands(acc)) do
      {:ok, path}
    else
      {:fail, :intervening_terrain}
    end
  end

  defp range_to_target(%Straight{} = path) do
    #turret = Acc.turret(acc, turret_id)
    #attacker = Acc.attacker(acc)
    #magnitude =
    #  target_vector
    #  |> CSys.Conversion.convert_from_world_vector(attacker, Turret.position_csys(turret))
    #  |> Vector.magnitude
    range = Straight.length(path)
    if range <= 1000 do
      {:ok, range}
    else
      {:fail, :out_of_range}
    end
  end

  defp fire_turret(%Acc{} = acc, turret_id, turret_angle, _range, _path) do
    # TODO introduce randomness (larger the range, lower liklihood)
    attacker =
      acc
      |> Acc.attacker
      |> Unit.rotate_turret(turret_id, turret_angle)
    turn_number = Acc.turn_number(acc)
    target =
      acc
      |> Acc.target
    # TODO rename Unit.update_status
      |> Unit.apply_status(&Unit.Status.take_damage(&1, 10, turn_number))
    pose = muzzle_flash_pose(attacker, turret_id)
    ordnance_hit_angle =
      pose
      |> Pose.flip
      |> Pose.angle
    ordnance_hit_pose =
      target
      |> Unit.position
      |> Pose.new(ordnance_hit_angle)
    animations = [
      Animation.Build.large_muzzle_flash(pose, 1),
      # TODO calculate the ordnance flight time instead of guessing
      Animation.Build.ordnance_hit(ordnance_hit_pose, 1.1)
    ]
    Acc.put(acc, attacker, target, animations)
  end

  def muzzle_flash_pose(unit, turret_id) do
    # TODO move to Unit
    turret = Unit.turret(unit, turret_id)
    position_vector =
      turret
      |> Turret.gun_barrel_vector
      |> CSys.Conversion.convert_to_world_vector(unit, turret)
    angle = CSys.Conversion.sum_angles(turret, unit)
    Pose.new(position_vector, angle)
  end

  def move_turret_to_neutral(acc, _turret_id) do
    # TODO implement
    acc
  end
end
