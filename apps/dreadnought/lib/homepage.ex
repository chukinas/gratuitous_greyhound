defmodule Dreadnought.Homepage do

  use Dreadnought.Core.Mission.Spec
  use Dreadnought.Homepage.Helpers
  use Spatial.LinearAlgebra
  use Spatial.PositionOrientationSize
  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Unit
  alias Dreadnought.Core.UnitAction
  alias Dreadnought.Homepage.Mission, as: HomepageMission
  alias Util.IdList

  # *** *******************************
  # *** CONSTRUCTORS

  def build_mission do
    HomepageMission.build(@mission_name)
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
    unit_id
    |> hull_by_unit_id
    |> HomepageMission.do_new(unit_id, @mission_name)
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

end
