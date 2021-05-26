alias ChukinasWeb.Router.Helpers, as: Routes

defmodule Chukinas.Sessions do
  @moduledoc """
  The Sessions context.
  """

  #import Ecto.Changeset
  alias Chukinas.Sessions.UserSession

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
    IOP.inspect user_session, "sessions url"
    [
      URI.to_string(socket.host_uri),
      path(socket, user_session)
    ]
    |> Enum.join
  end

  defdelegate room(user_session), to: UserSession

  # *** *******************************
  # *** ROOM

  #def get_room(nil), do: ""
  ##def get_room(%UserSession{room_slug: room}), do: room
  #def get_room(%Ecto.Changeset{} = changeset) do
  #  get_field(changeset, :room_slug, "")
  #end

  #def list_rooms do
  #  raise "TODO"
  #end

  #def create_room(attrs \\ %{}) do
  #  raise "TODO"
  #end

  #def update_room(%Room{} = room, attrs) do
  #  raise "TODO"
  #end

  #def delete_room(%Room{} = room) do
  #  raise "TODO"
  #end

  #def change_room(%Room{} = room, _attrs \\ %{}) do
  #  raise "TODO"
  #end
end
