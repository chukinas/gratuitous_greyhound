alias ChukinasWeb.Router.Helpers, as: Routes
alias Chukinas.Sessions.Players
alias Chukinas.Sessions.Room
alias Chukinas.Sessions.Rooms
alias Chukinas.Sessions.User
alias Chukinas.Sessions.UserRegistry

defmodule Chukinas.Sessions do
  @moduledoc """
  The Sessions context.
  """

  #import Ecto.Changeset
  alias Chukinas.Sessions.UserSession

  # *** *******************************
  # *** Users

  def new_user do
    user = User.new()
    UserRegistry.register(user |> User.uuid)
    user
  end

  def new_uuid do
    Ecto.UUID.generate()
  end

  # *** *******************************
  # *** UserSession

  def user_session_changeset(data, attrs) do
    UserSession.Changeset.changeset(data, attrs)
  end

  def list_user_sessions do
    raise "TODO"
  end

  def create_user_session(attrs \\ %{})
  def create_user_session(nil), do: create_user_session(%{})
  def create_user_session(attrs) do
    UserSession.Changeset.create_user_session(nil, attrs)
  end

  def update_user_session(user_session, attrs) do
    UserSession.Changeset.create_user_session(user_session, attrs)
  end

  #def delete_user_session(%UserSession{} = user_session) do
  #  raise "TODO"
  #end

  #def change_user_session(%UserSession{} = user_session, _attrs \\ %{}) do
  #  raise "TODO"
  #end

  # TODO this should maybe accept a path helper instead....
  # ... when is_function(func, 2)
  # TODO swap the arguments so things pipe nicer
  def path(socket, %UserSession{} = user_session) do
    room = user_session |> UserSession.room
    path(socket, room)
  end
  def path(socket, %Ecto.Changeset{} = user_session) do
    room = user_session |> UserSession.Changeset.room
    path(socket, room)
  end
  def path(socket, nil = _room) do
    Routes.dreadnought_path(socket, :room)
  end
  def path(socket, room) when is_binary(room) do
    Routes.dreadnought_path(socket, :room, room)
  end

  def url(socket, user_session) do
    [
      URI.to_string(socket.host_uri),
      path(socket, user_session)
    ]
    |> Enum.join
  end

  defdelegate room(user_session), to: UserSession

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
    {:ok, user}
  end

  def get_room_from_player_uuid(player_uuid) do
    with {:ok, room_name} <- Players.fetch(player_uuid),
         %Room{} = room <- Rooms.get(room_name) do
      room
    else
      _ -> nil
    end
  end

end
