defmodule Chukinas.Sessions.Players do

  alias Chukinas.Sessions.PlayerRegistry
  alias Chukinas.Sessions.PlayerRooms

  def send_room(player_uuid, room) do
    for pid <- PlayerRegistry.pids(player_uuid) do
      send pid, {:update_room, room}
    end
  end

  def subscribe(player_uuid) do
    PlayerRegistry.register(player_uuid)
  end

  @spec set_room(any) :: :ok
  def set_room(%{player_uuid: player_uuid, room_name: room_name}) do
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
