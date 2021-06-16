defmodule Chukinas.Sessions do

  @moduledoc """
  The Sessions context
  """

  alias Chukinas.Sessions.PlayerRegistry
  alias Chukinas.Sessions.PlayerRooms
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.RoomJoin
  alias Chukinas.Sessions.Rooms

  # *** *******************************
  # *** Users

  # TODO rename `register_liveview`?
  def register_uuid(player_uuid) do
    PlayerRegistry.register(player_uuid)
  end

  # *** *******************************
  # *** ROOM JOIN

  def room_join_types, do: RoomJoin.types()

  defdelegate room_join_changeset(data, attrs), to: RoomJoin, as: :changeset

  defdelegate room_join_validate(attrs), to: RoomJoin, as: :validate

  @spec join_room(RoomJoin.t) :: :ok
  def join_room(%RoomJoin{room_name: room, player_name: player_name, player_uuid: uuid}) do
    {:member_number, _player_id} = Rooms.add_member(room, uuid, player_name)
    PlayerRooms.register(uuid, room)
  end

  # *** *******************************
  # *** ROOM

  def leave_room(player_uuid) do
    # TODO do not manually set the liveview's room to nil
    room_name = PlayerRooms.pop(player_uuid)
    Rooms.remove_player(room_name, player_uuid)
  end

  def get_room_from_player_uuid(player_uuid) do
    with {:ok, room_name} <- PlayerRooms.fetch(player_uuid),
         %Room{} = room   <- Rooms.get(room_name) do
      room
    else
      response ->
        IOP.inspect response, "sessions, get room"
        nil
    end
  end

end
