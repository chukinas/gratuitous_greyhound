defmodule Chukinas.Dreadnought.CombatAction.Accumulator do

  alias Chukinas.Dreadnought.Gunfire
  alias Chukinas.Dreadnought.Island
  alias Chukinas.Dreadnought.Unit
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
  # *** GETTERS

  def attacker(%__MODULE__{attacker: unit}), do: unit
  def target(%__MODULE__{target: unit}), do: unit
  def turn_number(%__MODULE__{turn_number: turn_number}), do: turn_number
  def islands(%__MODULE__{islands: islands}), do: islands

  def to_tuple(%__MODULE__{
    attacker: attacker,
    target: target,
    gunfires: gunfires
  }), do: {attacker, target, gunfires}

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = acc, attacker, target, gunfire) do
    %__MODULE__{acc |
      attacker: attacker,
      target: target,
    }
    |> Maps.push(:gunfires, gunfire)
  end

  # *** *******************************
  # *** API

  def turret(%__MODULE__{attacker: unit}, turret_id), do: Unit.turret(unit, turret_id)
end
