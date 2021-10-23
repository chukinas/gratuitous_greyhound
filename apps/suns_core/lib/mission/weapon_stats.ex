defmodule SunsCore.Mission.Weapon.Stats do

  alias SunsCore.Mission.Scale
  alias SunsCore.DieRoller, as: Dice

  @type symbol :: atom
  @type range :: {min_range :: 0..18, max_range :: 3..36}

  use TypedStruct
  typedstruct enforce: true do
    field :symbol, symbol
    field :range, range
    field :die_count, 1..4
    # TODO there should be a typespec for this
    field :die_sides, Dice.sides
    field :damage, 1..5
  end

  def facility_laser_turrets(scale) do
    %__MODULE__{
      symbol: :laser_turrets,
      range: {0, 6},
      die_count: Scale.divide_by_two(scale),
      die_sides: 6,
      damage: 1
    }
  end

  def space_kraken(scale, :primary) do
    %__MODULE__{
      symbol: :mouth_parts,
      range: {0, 3},
      die_count: Scale.divide_by_two(scale),
      die_sides: 10,
      damage: 3
    }
  end

  def space_kraken(scale, :aux) do
    %__MODULE__{
      symbol: :tentacles,
      range: {0, 3},
      die_count: scale,
      die_sides: 6,
      damage: 1
    }
  end

end
