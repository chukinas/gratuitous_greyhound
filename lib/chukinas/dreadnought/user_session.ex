# TODO move this to the 'state' folder
defmodule Chukinas.Dreadnought.UserSession do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :room, :string
  end

  def changeset(user_session, attrs) do
    user_session
    |> cast(attrs, [:username, :room])
    |> validate_required([:username, :room])
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def empty do
    changeset(%__MODULE__{}, %{username: "joe", room: "hello"})
  end
end
