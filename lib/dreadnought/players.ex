defmodule Dreadnought.Players do

  alias Dreadnought.Core.Player
  alias Dreadnought.Players.MissionNameRegistry
  alias Dreadnought.Players.ProcessRegistry

  def send_room(player_uuid, room) do
    for pid <- ProcessRegistry.pids(player_uuid) do
      send pid, {:update_mission, room}
    end
  end

  @doc"""
  Subscribe a LiveView to a Player UUID.
  """
  def register_liveview(player_uuid) do
    ProcessRegistry.register(player_uuid)
  end

  def register_mission_name(%Player{uuid: player_uuid, mission_name: room_name}) do
    MissionNameRegistry.register(player_uuid, room_name)
    |> IOP.inspect("Players.register_mission_name")
  end

  def fetch_mission_name(player_uuid) do
    MissionNameRegistry.fetch(player_uuid)
  end

  def drop_player(player_uuid) do
    MissionNameRegistry.delete(player_uuid)
  end

end
