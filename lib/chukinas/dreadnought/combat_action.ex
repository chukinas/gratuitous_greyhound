defmodule Chukinas.Dreadnought.CombatAction do

  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Animations
  alias Chukinas.Dreadnought.CombatAction.Accumulator, as: Acc
  alias Chukinas.Dreadnought.Turret
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Dreadnought.Unit.Event, as: Ev
  alias Chukinas.Paths
  alias Chukinas.Util.IdList

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
      {:ok, path         } <- Acc.path_to_target(acc, target_vector, turret_id),
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

  @spec turret_angle(Acc.t, {number, number}, integer) :: {:ok, number} | {:fail, :out_of_fire_arc}
  defp turret_angle(%Acc{} = acc, target_vector, turret_id) do
    turret = Acc.turret(acc, turret_id)
    attacker = Acc.attacker(acc)
    desired_angle =
      target_vector
      |> vector_wrt_inner_observer([attacker, turret |> vector_from_position])
      |> vector_to_angle
    case Turret.normalize_desired_angle(turret, desired_angle) do
      {:ok, angle} -> {:ok, angle}
      {_, _angle} -> {:fail, :out_of_fire_arc}
    end
  end

  defp range_to_target(path) do
    range = Paths.traversal_distance(path)
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
    {delay_discharge, delay_hit} = {1, 1.1}
    damage_event = Ev.Damage.new(10, turn_number, delay_hit)
    target =
      acc
      |> Acc.target
      |> Unit.put(damage_event)
    pose = muzzle_flash_pose(attacker, turret_id)
    ordnance_hit_angle =
      pose
      |> flip_angle
      |> angle
    ordnance_hit_pose =
      target
      # TODO position_new is redundant
      |> position_new
      |> pose_new(ordnance_hit_angle)
    animations = [
      Animations.large_muzzle_flash(pose, delay_discharge),
      # TODO calculate the ordnance flight time instead of guessing
      Animations.ordnance_hit(ordnance_hit_pose, delay_hit)
    ]
    Acc.put(acc, attacker, target, animations)
  end

  def muzzle_flash_pose(unit, turret_id) do
    # TODO move to Unit
    turret = Unit.turret(unit, turret_id)
    angle = angle_from_sum(turret, unit)
    turret
    |> Turret.gun_barrel_vector
    |> vector_wrt_outer_observer([turret, unit])
    |> pose_new(angle)
  end

  def move_turret_to_neutral(acc, _turret_id) do
    # TODO implement
    acc
  end
end
