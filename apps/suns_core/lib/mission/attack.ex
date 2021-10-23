defmodule SunsCore.Mission.Attack do

  alias SunsCore.Mission.Attack.Subject
  alias SunsCore.Mission.Weapon
  alias SunsCore.Mission.Weapon.RangeAndArc
  alias SunsCore.Space
  alias SunsCore.Space.TablePose

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :attacker, Subject.t
    field :target, Subject.t
    field :weapons_type, Weapon.type
    field :dice, pos_integer
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Subject.t, Subject.t, Weapon.type, integer | :all) :: t
  def new(attacker, target, weapons_type, die_count \\ :all)
  when weapons_type in ~w/primary aux/a
  and (die_count == :all or is_integer(die_count)) do
    max_dice = Subject.max_attack_dice(attacker, weapons_type)
    dice_count =
      case die_count do
        :all -> max_dice
        count when count <= max_dice -> die_count
      end
    %__MODULE__{
      attacker: attacker,
      target: target,
      weapons_type: weapons_type,
      dice: dice_count
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  # *** *******************************
  # *** CONVERTERS (boolean targeting requirements)
  #
  # TODO add requirement for `has_this_type_of_weapon`
  # for examgle, the fighter does not have primary weapons

  def target_is_not_friendly?(%__MODULE__{} = attack) do
    Subject.controller(attack.attacker) !=
      Subject.controller(attack.target)
  end

  def target_has_silhouette?(attack) do
    attack
    |> target
    |> Subject.silhouette
    |> Kernel.>(0)
  end

  def on_same_table?(attack) do
    Space.table_id(attack.attacker) === Space.table_id(attack.target)
  end

  @spec in_range_and_fire_arc?(t) :: boolean
  def in_range_and_fire_arc?(%__MODULE__{} = attack) do
    range_and_arc =
      RangeAndArc.new(
        Subject.weapon_range(attack.attacker, attack.weapons_type),
        Subject.weapon_arc(attack.attacker, attack.weapons_type)
      )
    attacking_poseables = Subject.individuals(attack.attacker)
    target_poseables = Subject.individuals(attack.target)
    Enum.any?(attacking_poseables, fn %TablePose{} = attacking_poseable ->
      TablePose.in_range_and_fire_arc?(attacking_poseable, target_poseables, range_and_arc)
    end)
  end

end
