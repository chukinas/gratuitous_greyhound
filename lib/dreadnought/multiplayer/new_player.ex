defmodule Dreadnought.Multiplayer.NewPlayer do

  use Ecto.Schema
  @primary_key false

  alias Dreadnought.Sessions.RoomName
  alias Ecto.Changeset

  # *** *******************************
  # *** TYPES

  @types %{
    room_name: :string,
    player_uuid: :string,
    player_name: :string
  }

  @required_fields Map.keys @types

  embedded_schema do
    for key <- Map.keys(@types) do
      Macro.escape(field(key, :string))
    end
  end

  @type t :: %__MODULE__{
    room_name: String.t,
    player_uuid: String.t,
    player_name: String.t
  }

  # *** *******************************
  # *** API

  def changeset(data \\ %__MODULE__{}, attrs) do
    path_len_msg = "path should be 5 - 20 characters"
    data
    |> Changeset.cast(attrs, @required_fields)
    |> Changeset.update_change(:player_name, &String.trim/1)
    |> Changeset.update_change(:room_name, &RoomName.slugify/1)
    |> Changeset.validate_required(@required_fields)
    |> Changeset.validate_length(:player_name, min: 2, max: 15)
    |> Changeset.validate_length(:room_name, min: 5, max: 20, message: path_len_msg)
  end

  def validate(data \\ %__MODULE__{}, attrs) do
    changeset = changeset(data, attrs)
    if changeset.valid? do
      join_room = Changeset.apply_changes(changeset)
      {:ok, join_room}
    else
      {:error, changeset}
    end
  end

  def types, do: @types

end
