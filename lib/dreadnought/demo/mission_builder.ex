defmodule Dreadnought.Demo.MissionBuilder do

  use Dreadnought.Core.Mission.Spec
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Builder, as: MissionBuilder
  alias Dreadnought.Core.MissionHelpers
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.UnitBuilder

  @behaviour MissionBuilder

  # *** *******************************
  # *** CONSTRUCTORS

  @impl MissionBuilder
  def new(player_uuid) when is_binary(player_uuid) do
    {grid, margin} = MissionHelpers.medium_map()
    mission_spec = new_mission_spec(__MODULE__, player_uuid)
    Mission.new(mission_spec, grid, margin)
    |> Map.put(:islands, MissionHelpers.islands())
    |> Mission.put(UnitBuilder.build(:blue_destroyer, 1, 1, pose_new(100, 100, 45)))
    |> Mission.put(Player.new_human(1, player_uuid, "Player"))
  end

  @impl MissionBuilder
  def mission_spec(mission_name) when is_binary(mission_name) do
    new_mission_spec(__MODULE__, mission_name)
  end

end
