defmodule Chukinas.Sessions do
  @moduledoc """
  The Sessions context.
  """

  alias Chukinas.Sessions.UserSession
  alias Chukinas.Sessions.Room

  # *** *******************************
  # *** UserSession

  defdelegate empty_user_session, to: UserSession, as: :empty
  # TODO does this belong here?
  defdelegate changeset_user_session(user_session, attrs), to: UserSession, as: :changeset
  defdelegate changeset_user_session(attrs), to: UserSession, as: :changeset
  # TODO Should this just be Ecto.Changeset.apply?
  def apply_changes(%Ecto.Changeset{} = changeset), do: UserSession.apply(changeset)
  defdelegate get_room_slug(changeset), to: UserSession

  def list_user_sessions do
    raise "TODO"
  end

  def get_user_session!(id), do: raise "TODO"

  def create_user_session(attrs \\ %{}) do
    raise "TODO"
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

  # *** *******************************
  # *** ROOM

  def list_rooms do
    raise "TODO"
  end

  def get_room!(id), do: raise "TODO"

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
