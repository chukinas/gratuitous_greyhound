defmodule SunsCore.Mission.Weapon do

  alias SunsCore.Mission.Scale
  alias SunsCore.Mission.Weapon.Stats

  # *** *******************************
  # *** TYPES

  defmodule RangeAndArc do
    use Util.GetterStruct
    getter_struct do
      field :range_min, pos_integer
      field :range_max, pos_integer
      field :arc, pos_integer
    end
    @spec new(Stats.range, pos_integer) :: t
    def new({range_min, range_max} = _range, arc) do
      %__MODULE__{
        range_min: range_min,
        range_max: range_max,
        arc: arc
      }
    end
  end

  @typep t :: Stats.symbol | {Stats.symbol, Scale.t}
  @type spec :: t
  # TODO does this belong here...?
  @type type :: :primary | :aux
  @type range :: Stats.range

  types = [
    #   SYMBOL          MIN/MAXRANGE  ATTACKDICE  DAMAGE
    ~w/ light_blasters   0   3        1D6         1     /,
    ~w/ blasters         0   6        2D6         1     /,
    ~w/ auto_blasters    0   6        3D6         1     /,
    ~w/ turbo_blasters   0   6        4D6         1     /,
    ~w/ laser_cannon     0   9        2D8         2     /,
    ~w/ light_railguns   9  18        2D8         2     /,
    ~w/ defense_grid     0   9        4D8         2     /,
    ~w/ torpedoes        6  12        1D10        3     /,
    ~w/ cruise_missiles 18  36        3D10        3     /,
    ~w/ heavy_railguns   9  18        2D12        5     /,
    ~w/ mining_laser     0   2        2D12        5     /,
    ~w/ macro_beam      12  24        2D12        5     /,
    ~w/ planet_smasher  12  24        4D12        5     /
  ]

  [example_weapon | _] = weapons =
    for [symbol, min_range, max_range, attack_dice, damage] <- types do
      [die_count, die_sides] =
        attack_dice
        |> String.split("D")
        |> Enum.map(&String.to_integer/1)
      %Stats{
        symbol: String.to_atom(symbol),
        range: {String.to_integer(min_range), String.to_integer(max_range)},
        die_count: die_count,
        die_sides: die_sides,
        damage: String.to_integer(damage)
      }
    end

  fields =
    example_weapon
    |> Map.drop([:symbol])
    |> Map.keys

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  @spec stats(t) :: Stats.t
  # For the ship-board weapons above:
  for weapon <- weapons do
    def stats(unquote(weapon.symbol)) do
      unquote(Macro.escape(weapon))
    end
  end
  # For the scale-based objectives:
  def stats({:laser_turrets, scale}), do: Stats.facility_laser_turrets(scale)
  def stats({:mouth_parts, scale}), do: Stats.space_kraken(scale, :primary)
  def stats({:tentacles, scale}), do: Stats.space_kraken(scale, :aux)

  # The getters. Example:
  # def range(:macro_beam) do ...
  for field <- fields do
    def unquote(field)(weapon_symbol) when is_atom(weapon_symbol) do
      stats(weapon_symbol)
      |> Map.fetch!(unquote(field))
    end
  end

end
