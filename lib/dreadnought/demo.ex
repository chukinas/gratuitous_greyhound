defmodule Dreadnought.Demo do

  alias Dreadnought.Missions
  alias Dreadnought.Demo.Mission, as: DemoMission
  alias Dreadnought.Demo.Player, as: DemoPlayer

  def start(player_uuid) do
    player_uuid
    |> DemoMission.mission_spec
    |> DemoPlayer.build(player_uuid)
    |> Missions.add_player
  end

end
