defmodule Chukinas.Sessions do

  @moduledoc """
  The Sessions context
  """

  alias Chukinas.Sessions.PlayerRegistry
  alias Chukinas.Sessions.PlayerRooms
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.RoomJoinChangeset
  alias Chukinas.Sessions.Rooms
  alias Chukinas.Sessions.User
  alias Chukinas.Sessions.UserSession

  # *** *******************************
  # *** Users

  def user_from_uuid(uuid) do
    User.new(uuid)
  end

  def new_uuid do
    # TODO replace calls to ectouuid with a call to this func
    Ecto.UUID.generate()
  end

  # TODO rename `register_liveview`?
  def register_uuid(player_uuid) do
    PlayerRegistry.register(player_uuid)
  end

  # *** *******************************
  # *** UserSession

  def user_session_changeset(data, attrs) do
    RoomJoinChangeset.changeset(data, attrs)
  end

  def create_user_session(attrs \\ %{})
  def create_user_session(nil), do: create_user_session(%{})
  def create_user_session(attrs) do
    RoomJoinChangeset.create_user_session(nil, attrs)
  end

  def room_name(%UserSession{} = user_session) do
    user_session |> UserSession.room
  end
  def room_name(%Ecto.Changeset{} = user_session) do
    user_session |> RoomJoinChangeset.room
  end

  # *** *******************************
  # *** ROOM

  def join_room(user_session, attrs) do
    RoomJoinChangeset.create_user_session(user_session, attrs)
  end

  def do_join_room(room_name, player_uuid, player_name) when is_binary(room_name) do
    # TODO Rooms.add_member should just return an :ok
    {:member_number, _player_id} = Rooms.add_member(room_name, player_uuid, player_name)
    :ok = PlayerRooms.register(player_uuid, room_name)
    # TODO then this :ok wouldn't be needed
    :ok
  end

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
