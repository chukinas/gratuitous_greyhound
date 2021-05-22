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
    |> validate_length(:username, max: 15)
    |> validate_format(:username, ~r/\s*(?:[\w\.]\s*){2,}+$/, message: "should be at least 2 alphanumeric characters")
    |> validate_length(:room, max: 15)
    |> validate_format(:room, ~r/\s*(?:[\w\.]\s*){8,}+$/, message: "should be at least 8 alphanumeric characters")
  end

  def changeset(attrs) do
    changeset(%__MODULE__{}, attrs)
  end

  def empty do
    changeset(%__MODULE__{}, %{})
  end
end
