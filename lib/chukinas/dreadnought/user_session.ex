# TODO move this to the 'state' folder
defmodule Chukinas.Dreadnought.UserSession do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :room, :string
  end

  def changeset(user_session, attrs) do

    changeset =
      user_session
      |> cast(attrs |> slugify_room, [:username, :room])
      |> validate_required([:username, :room])
      |> validate_length(:username, max: 15)
      |> validate_format(:username, ~r/\s*(?:[\w\.]\s*){2,}+$/, message: "should be at least 2 alphanumeric characters")
      |> validate_length(:room, max: 15)
      |> validate_format(:room, ~r/\s*(?:[\w\.]\s*){8,}+$/, message: "should be at least 8 alphanumeric characters")
    if changeset.valid? do
      {:ok, changeset}
      |> IOP.inspect("user session")
    else
      {:error, changeset}
      |> IOP.inspect("user session")
    end
  end

  def maybe_url(changeset) do

  end

  defp slugify_room(attrs) do
    if Map.has_key?(attrs, "room") do
      Map.update!(attrs, "room", &slugify/1)
    else
      attrs
    end
    |> IOP.inspect("slugify")
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
    |> Map.take([:username])
    |> Map.put(:room_slug, slugify(user_session.room))
  end

  def slugify(room) do
    ChukinasWeb.Plugs.SanitizeRoomName.slugify(room)
  end
end
