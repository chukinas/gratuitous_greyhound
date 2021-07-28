defmodule Chukinas.Dreadnought.MissionBuilder.Homepage do

  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.ActionSelection
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Dreadnought.UnitAction
  alias Chukinas.Dreadnought.UnitBuilder
  alias Chukinas.Util.IdList

  # *** *******************************
  # *** TYPES

  @target_player_id 1
  @target_unit_id 1
  @main_player_id 2
  @starting_main_unit_id 2

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new :: Mission.t
  def new do
    new_no_gunfire(:red_cruiser, @starting_main_unit_id)
    |> next_gunfire
  end

  defp new_no_gunfire(hull, main_unit_id) do
    {grid, margin} = MissionBuilder.medium_map()
    inputs = [
      Player.new_manual(@main_player_id),
      Player.new_manual(@target_player_id),
    ]
    Mission.new("homepage", grid, margin)
    |> Mission.put(inputs)
    |> put_target_unit
    |> put_main_unit(hull, main_unit_id)
    |> Mission.start
  end

  # *** *******************************
  # *** REDUCERS

  def next_gunfire(mission) do
    units = Mission.units(mission)
    action_selection =
      ActionSelection.new(main_unit_id(mission), units, [])
      |> ActionSelection.put(UnitAction.fire_upon(main_unit_id(mission), @target_unit_id))
    mission
    |> position_target_randomly_within_arc
    |> Mission.put_action_selection_and_end_turn(action_selection)
  end

  def next_unit(mission) do
    unit_id = next_main_unit_id(mission)
    new_no_gunfire(:red_destroyer, unit_id)
  end

  # *** *******************************
  # *** CONVERTERS

  def main_unit(mission) do
    unit_id = main_unit_id(mission)
    Mission.unit_by_id(mission, unit_id)
  end

  defdelegate turn_number(mission), to: Mission

  # *** *******************************
  # *** PRIVATE REDUCERS

  defp put_target_unit(mission) do
    unit =
      :blue_destroyer
      |> UnitBuilder.build(@target_unit_id, @target_player_id)
    Mission.put(mission, unit)
  end

  defp put_main_unit(mission, hull, unit_id) do
    units =
      [
        target_unit(mission),
        UnitBuilder.build(hull, unit_id, @main_player_id) |> Unit.position_mass_center
      ]
    %Mission{mission | units: units}
  end

  defp position_target_randomly_within_arc(mission) do
    target_pose =
      mission
      |> main_unit
      |> Unit.world_coord_random_in_arc(500)
      |> pose_from_vector
    Mission.update_unit mission, @target_unit_id, &merge_pose!(&1, target_pose)
  end

  # *** *******************************
  # *** PRIVATE CONVERTERS

  defp main_unit_id(mission) do
    mission
    |> Mission.units
    |> IdList.ids
    |> Enum.max
  end

  defp next_main_unit_id(mission) do
    case Mission.units(mission) do
      [] -> @starting_main_unit_id
      _units -> main_unit_id(mission) + 1
    end
  end

  defp target_unit(mission), do: Mission.unit_by_id(mission, @target_unit_id)

end
