# TODO move this to the 'state' folder
defmodule Chukinas.Dreadnought.UserSession do
  use ChukinasWeb.Plugs.SanitizeRoomName
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :room, :string
    field :room_slug, :string
  end

  def changeset(user_session, attrs) do
    changeset =
      user_session
      |> cast(attrs, [:username, :room])
      |> update_change(:username, &String.trim/1)
      |> put_room_slug
      |> validate_required([:username, :room])
      |> validate_length(:username, min: 2, max: 15)
      |> validate_room_slug_alnum_len
    if changeset.valid? do
      {:ok, changeset}
    else
      {:error, changeset}
    end
  end

  def get_room_slug(%Ecto.Changeset{} = changeset) do
    changeset
    |> get_field(:room_slug)
  end

  defp validate_room_slug_alnum_len(changeset) do
    room = get_change(changeset, :room, nil)
    room_alnum =
      changeset
      |> get_field(:room_slug)
      |> to_alnum
    changeset
    |> put_change(:room, room_alnum)
    |> validate_length(:room, min: 5, message: "should be at least 5 alphanumeric characters")
    |> validate_length(:room, max: 20, message: "should be at most 20 alphanumeric characters")
    |> put_change(:room, room)
  end

  def put_room_slug(changeset) do
    room_slug =
      changeset
      |> get_field(:room)
      |> slugify
    changeset
    |> put_change(:room_slug, room_slug)
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def empty do
    changeset(%__MODULE__{}, %{})
  end

  def apply(changeset) do
    user_session =
      changeset
      |> apply_changes
    user_session
    |> Map.take([:username, :room_slug])
  end

end
