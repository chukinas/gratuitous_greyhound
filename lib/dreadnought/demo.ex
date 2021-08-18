defmodule Dreadnought.Demo do

  alias Dreadnought.Missions
  alias Dreadnought.Demo.Mission, as: DemoMission
  alias Dreadnought.Demo.Player, as: DemoPlayer

  def start(player_uuid) do
    mission_spec = DemoMission.mission_spec(player_uuid)
    player = DemoPlayer.build(mission_spec, player_uuid)
    Missions.add_player(player)
    Missions.toggle_ready(mission_spec, player)
  end

end
