# TODO rename RoomJoin
defmodule Chukinas.Sessions.RoomJoinChangeset do

  use Ecto.Schema

  import Ecto.Changeset

  # TODO factor this out, so I can delete UsesSession
  alias Chukinas.Sessions.UserSession
  alias Chukinas.Sessions.RoomName

  # *** *******************************
  # *** TYPES

  embedded_schema do
    field :username, :string
    field :room_raw, :string
    field :room_slug, :string
  end

  # *** *******************************
  # *** NEW

  # TODO remove dependency on UserSession
  def user_session_to_schema(%UserSession{} = us = _user_session) do
    %__MODULE__{
      # TODO rename one of these to room_name
      username: us.username,
      room_raw: UserSession.pretty_room_name(us),
      room_slug: us.room
    }
  end

  # TODO remove dependency on UserSession
  def schema_to_user_session(%__MODULE__{
    username: username,
    room_slug: room
  }) do
    UserSession.new(username, room)
  end

  # *** *******************************
  # *** API

  # TODO remove dependency on UserSession
  def changeset(nil, attrs) do
    changeset(%UserSession{}, attrs)
  end

  # TODO remove dependency on UserSession
  def changeset(%UserSession{} = user_session, attrs) do
    user_session
    |> user_session_to_schema
    |> changeset(attrs)
  end

  def changeset(data, attrs) do
    data
    |> cast(attrs, [:username, :room_raw])
    |> maybe_change_room_slug
    |> update_change(:username, &String.trim/1)
    |> validate_required([:username, :room_slug])
    |> validate_length(:username, min: 2, max: 15)
    |> validate_length(:room_slug, min: 5, message: "path should be at least 5 characters")
    |> validate_length(:room_slug, max: 20, message: "path should be at most 20 characters")
  end

  def create_user_session(user_session, attrs) do
    changeset = user_session |> changeset(attrs)
    if changeset.valid? do
      user_session =
        changeset
        |> apply_changes
        |> schema_to_user_session
      {:ok, user_session}
    else
      {:error, changeset}
    end
  end

  # TODO where used?
  def room(changeset) do
    get_field(changeset, :room_slug)
  end

  # *** *******************************
  # *** ATTRIBUTES TRANSFORMS

  def maybe_change_room_slug(%Ecto.Changeset{} = changeset) do
    case get_change(changeset, :room_raw, nil) do
      nil ->
        changeset
      room_raw ->
        room_slug = RoomName.slugify(room_raw)
        changeset |> put_change(:room_slug, room_slug)
    end
  end

end
