defmodule Chukinas.Sessions do

  @moduledoc """
  The Sessions context
  """

  alias Chukinas.Sessions.Players
  alias Chukinas.Sessions.Rooms
  alias Chukinas.Sessions.RoomJoin

  # *** *******************************
  # *** Users

  # TODO rename `register_liveview`?
  # TODO or to `subscribe_to_player_uuid`?
  def register_uuid(player_uuid) do
    Players.subscribe(player_uuid)
  end

  # *** *******************************
  # *** ROOM JOIN

  def room_join_types, do: RoomJoin.types()

  defdelegate room_join_changeset(data, attrs), to: RoomJoin, as: :changeset

  defdelegate room_join_validate(attrs), to: RoomJoin, as: :validate

  def join_room(room_join) do
    :ok = Rooms.add_member(room_join)
    :ok = Players.set_room(room_join)
  end

  # *** *******************************
  # *** ROOM

  def leave_room(player_uuid) do
    room_name = Players.get_room_name(player_uuid)
    Players.leave_room(player_uuid)
    Rooms.remove_player(room_name, player_uuid)
  end

  def get_room_from_player_uuid(player_uuid) do
    with {:ok, room_name} <- Players.fetch_room_name(player_uuid),
         {:ok, room}      <- Rooms.fetch(room_name) do
      room
    else
      _response ->
        nil
    end
  end

end
