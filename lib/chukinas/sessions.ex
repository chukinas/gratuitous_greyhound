defmodule Chukinas.Sessions do
  @moduledoc """
  The Sessions context
  """

  alias Chukinas.Sessions.PlayerRooms
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.Rooms
  alias Chukinas.Sessions.User
  alias Chukinas.Sessions.PlayerRegistry
  alias Chukinas.Sessions.UserSession


  # *** *******************************
  # *** Users

  def new_user do
    user = User.new()
    PlayerRegistry.register(user |> User.uuid)
    user
  end

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
    UserSession.Changeset.changeset(data, attrs)
  end

  def create_user_session(attrs \\ %{})
  def create_user_session(nil), do: create_user_session(%{})
  def create_user_session(attrs) do
    UserSession.Changeset.create_user_session(nil, attrs)
  end

  def update_user_session(user_session, attrs) do
    UserSession.Changeset.create_user_session(user_session, attrs)
  end

  def room_name(%UserSession{} = user_session) do
    user_session |> UserSession.room
  end
  def room_name(%Ecto.Changeset{} = user_session) do
    user_session |> UserSession.Changeset.room
  end

  # *** *******************************
  # *** ROOM

  def join_room(%User{} = user, room_name)
  when is_binary(room_name) do
    {:member_number, player_id} =
      # TODO maybe this function can accept a map instead?
      Rooms.add_member(
        room_name,
        user |> User.uuid,
        user |> User.name
      )
    user = %User{user |
      room_name: room_name,
      player_id: player_id
    }
    PlayerRooms.register(User.uuid(user), room_name)
    {:ok, user}
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
