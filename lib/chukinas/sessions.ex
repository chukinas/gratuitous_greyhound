alias ChukinasWeb.Router.Helpers, as: Routes

defmodule Chukinas.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Changeset
  alias Chukinas.Sessions.UserSession
  alias Chukinas.Sessions.Room

  # *** *******************************
  # *** UserSession

  # TODO rename user_session_changeset
  def changeset_user_session(user_session \\ %UserSession{}, attrs) do
    UserSession.changeset(user_session, attrs)
  end

  def list_user_sessions do
    raise "TODO"
  end

  def get_user_session!(id), do: raise "TODO"

  def create_user_session(attrs \\ %{})
  def create_user_session(nil), do: create_user_session(%{})
  def create_user_session(attrs) do
    changeset = changeset_user_session(attrs)
    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  def update_user_session(%UserSession{} = user_session, attrs) do
    raise "TODO"
  end

  def delete_user_session(%UserSession{} = user_session) do
    raise "TODO"
  end

  def change_user_session(%UserSession{} = user_session, _attrs \\ %{}) do
    raise "TODO"
  end

  # TODO this should maybe accept a path helper instead....
  # ... when is_function(func, 2)
  def path(socket, user_session) do
    room = get_room(user_session)
    Routes.dreadnought_path(socket, :room, room)
  end

  def url(socket, user_session) do
    [
      URI.to_string(socket.host_uri),
      path(socket, user_session)
    ]
    |> Enum.join
  end

  # *** *******************************
  # *** ROOM

  def get_room(nil), do: ""
  def get_room(%UserSession{room_slug: room}), do: room
  def get_room(%Ecto.Changeset{} = changeset) do
    get_field(changeset, :room_slug, "")
  end

  # TODO replace with get_room
  defdelegate get_room_slug(changeset), to: UserSession

  # TODO this clause is temp until I have Lobby component
  def pretty_room_name(nil), do: "" |> IOP.inspect("sessions pretty")
  def pretty_room_name(string) when is_binary(string) do
    Room.Name.pretty(string)
  end
  def pretty_room_name(%UserSession{} = user_session) do
    UserSession.pretty_room_name(user_session)
  end

  def list_rooms do
    raise "TODO"
  end

  def create_room(attrs \\ %{}) do
    raise "TODO"
  end

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
