defmodule Dreadnought.Demo.Mission do

  use Dreadnought.Core.Mission.Builder
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Helpers
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.UnitBuilder

  # *** *******************************
  # *** CONSTRUCTORS

  @impl Builder
  def build(player_uuid) when is_binary(player_uuid) do
    {grid, margin} = Helpers.medium_map()
    Mission.new(mission_spec(player_uuid), grid, margin)
    |> Map.put(:islands, Helpers.islands())
    |> Mission.put(UnitBuilder.build(:blue_destroyer, 1, 1, pose_new(100, 100, 45)))
    |> Mission.put(Player.new_human(1, player_uuid, "Player"))
  end

end
