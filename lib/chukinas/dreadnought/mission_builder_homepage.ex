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

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new :: Mission.t
  def new do
    {grid, margin} = MissionBuilder.medium_map()
    inputs = [
      Player.new_manual(1),
      Player.new_manual(2),
    ]
    units = [
      UnitBuilder.build(:red_cruiser, 1, 1) |> Unit.position_mass_center,
      UnitBuilder.build(:blue_destroyer, 2, 2)
    ]
    Mission.new("homepage", grid, margin)
    |> Mission.put(inputs)
    |> Mission.put(units)
    |> Mission.start
    |> homepage_1_fire_upon_2
  end

  # *** *******************************
  # *** REDUCERS

  def homepage_1_fire_upon_2(mission) do
    units = Mission.units(mission)
    action_selection =
      ActionSelection.new(1, units, [])
      |> ActionSelection.put(UnitAction.fire_upon(1, 2))
    mission
    |> position_target_randomly_within_arc
    |> Mission.put_action_selection_and_end_turn(action_selection)
  end

  # *** *******************************
  # *** PRIVATE REDUCERS

  defp position_target_randomly_within_arc(mission) do
    target_pose =
      mission
      |> Mission.unit_by_id(1)
      |> Unit.world_coord_random_in_arc(500)
      |> pose_from_vector
    Mission.update_unit mission, 2, &merge_pose!(&1, target_pose)
  end

end
