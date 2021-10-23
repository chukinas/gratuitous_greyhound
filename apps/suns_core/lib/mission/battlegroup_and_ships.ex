defmodule SunsCore.Mission.BattlegroupAndShips do

  alias SunsCore.Mission.Battlegroup
  alias SunsCore.Mission.Ship
  #alias SunsCore.Space

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :battlegroup, Battlegroup.t
    field :ships, [Ship.t]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(battlegroup, all_ships) do
    battlegroup_id = Battlegroup.id(battlegroup)
    # TODO move this to Ship.Collection
    member_ships = Enum.filter(all_ships, &Ship.belongs_to?(&1, battlegroup_id))
    %__MODULE__{
      battlegroup: battlegroup,
      ships: member_ships
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl SunsCore.Mission.Attack.Subject do

    alias SunsCore.Mission.BattlegroupAndShips
    alias SunsCore.Mission.Battlegroup
    alias SunsCore.Mission.Battlegroup.Class
    alias SunsCore.Mission.Weapon
    alias SunsCore.Space.TablePose
    alias SunsCore.Space.Poseable

    def silhouette(bg_ships) do
      bg_ships
      |> BattlegroupAndShips.battlegroup
      |> Battlegroup.class_symbol
      |> Class.silhouette
    end

    def controller(bg_ships) do
      bg_ships
      |> BattlegroupAndShips.battlegroup
      |> Battlegroup.controller
    end

    @spec individuals(any) :: [TablePose.t]
    def individuals(%BattlegroupAndShips{ships: ships}) do
      Enum.map(ships, &Poseable.table_pose/1)
    end

    def max_attack_dice(%BattlegroupAndShips{} = bg_ships, weapon_type) do
      ship_count = bg_ships.ships |> Enum.count
      dice_count_per_ship =
        bg_ships
        |> BattlegroupAndShips.battlegroup
        |> Battlegroup.class_name
        |> Class.weapon_system_symbol(weapon_type)
        |> Weapon.die_count
      ship_count * dice_count_per_ship
    end

    def weapon_arc(_bg_ships, :primary), do: 45
    def weapon_arc(_bg_ships, :aux), do: 180

    def weapon_range(bg_ships, weapon_type) do
      bg_ships
      |> BattlegroupAndShips.battlegroup
      |> Battlegroup.class_symbol
      |> Class.weapon_spec(weapon_type)
      |> Weapon.range
    end

  end

end
