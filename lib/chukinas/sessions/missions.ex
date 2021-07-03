defmodule Chukinas.Sessions.Missions do

  alias Chukinas.Dreadnought.ActionSelection
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Sessions.Rooms

  def complete_player_turn(room_name, %ActionSelection{} = player_actions) do
    IOP.inspect("Missions complete_player_turn start")
    fun = &Mission.put(&1, player_actions)
    # TODO convert this to a non-hygienic macro
    Rooms.update_mission(room_name, fun)
    |> IOP.inspect("Missions complete_player_turn end")
  end

end
