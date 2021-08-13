defmodule Dreadnought.Players do

  alias Dreadnought.Core.Player
  alias Dreadnought.Players.Registry, as: PlayerRegistry
  alias Dreadnought.Players.Missions, as: PlayerRooms

  def send_room(player_uuid, room) do
    for pid <- PlayerRegistry.pids(player_uuid) do
      send pid, {:update_mission, room}
    end
  end

  @doc"""
  Subscribe a LiveView to a Player UUID.
  """
  def register_liveview(player_uuid) do
    PlayerRegistry.register(player_uuid)
  end

  def set_room(%Player{uuid: player_uuid, mission_name: room_name}) do
    PlayerRooms.register(player_uuid, room_name)
  end

  def get_room_name(player_uuid) do
    PlayerRooms.get(player_uuid)
  end

  def fetch_room_name(player_uuid) do
    PlayerRooms.fetch(player_uuid)
  end

  def leave_room(player_uuid) do
    PlayerRooms.delete(player_uuid)
  end

end
