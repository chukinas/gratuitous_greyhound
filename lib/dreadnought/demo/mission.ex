defmodule Dreadnought.Demo.Mission do

  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.MissionBuilder
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.UnitBuilder

  # *** *******************************
  # *** CONSTRUCTORS

  def new(room_name = player_uuid) do
    {grid, margin} = MissionBuilder.medium_map()
    Mission.new(room_name, grid, margin)
    |> Map.put(:islands, MissionBuilder.islands())
    |> Mission.put(UnitBuilder.build(:blue_destroyer, 1, 1, pose_new(100, 100, 45)))
    |> Mission.put(Player.new_human(1, player_uuid, "Player"))
  end

end
