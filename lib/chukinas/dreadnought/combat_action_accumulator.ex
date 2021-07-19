defmodule Chukinas.Dreadnought.CombatAction.Accumulator do

  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Gunfire
  alias Chukinas.Dreadnought.Island
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Collide
  alias Chukinas.Paths
  alias Chukinas.Util.Maps

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :attacker, Unit.t()
    field :target, Unit.t()
    field :turn_number, integer()
    field :gunfires, [Gunfire.t()]
    field :islands, [Island.t()]
  end

  # *** *******************************
  # *** NEW

  def new(attacker, target, turn_number, gunfires, islands) do
    %__MODULE__{
      attacker: attacker,
      target: target,
      turn_number: turn_number,
      gunfires: gunfires,
      islands: islands
    }
  end

  # *** *******************************
  # *** REDUCERS

  def put(%__MODULE__{} = acc, attacker, target, gunfire) do
    %__MODULE__{acc |
      attacker: attacker,
      target: target,
    }
    |> Maps.push(:gunfires, gunfire)
  end

  # *** *******************************
  # *** BOUNDARY

  def path_to_target(%__MODULE__{} = acc, target_vector, turret_id) do
    turret = turret(acc, turret_id)
    attacker = attacker(acc)
    turret_coord =
      turret
      |> vector_from_position
      |> vector_wrt_outer_observer(attacker)
    # rename `projectile_vector`?
    path_vector = vector_subtract(target_vector, turret_coord)
    angle = vector_to_angle(path_vector)
    path_start_pose = pose_new(turret_coord, angle)
    range = vector_to_magnitude(path_vector)
    path = Paths.straight_new(path_start_pose, range)
    if Collide.avoids_collision_with?(path, islands(acc)) do
      {:ok, path}
    else
      {:fail, :intervening_terrain}
    end
  end

  # *** *******************************
  # *** CONVERTERS

  def attacker(%__MODULE__{attacker: unit}), do: unit

  def islands(%__MODULE__{islands: islands}), do: islands

  def target(%__MODULE__{target: unit}), do: unit

  def to_tuple(%__MODULE__{
    attacker: attacker,
    target: target,
    gunfires: gunfires
  }), do: {attacker, target, gunfires}

  def turn_number(%__MODULE__{turn_number: turn_number}), do: turn_number

  def turret(%__MODULE__{attacker: unit}, turret_id), do: Unit.turret(unit, turret_id)

end
