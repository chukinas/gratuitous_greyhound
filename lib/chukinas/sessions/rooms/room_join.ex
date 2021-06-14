defmodule Chukinas.Sessions.RoomJoin do

  use Ecto.Schema
  @primary_key false

  alias Chukinas.Sessions.RoomName

  # *** *******************************
  # *** TYPES

  embedded_schema do
    field :room_name, :string
    field :player_uuid, :string
    field :player_name, :string
  end

  # *** *******************************
  # *** API

  def slugify_raw_room_name(%{raw_room_name: raw} = params) do
    room_name = RoomName.slugify(raw)
    Map.put(params, :room_name, room_name)
  end

  def changeset(attrs) do
    path_len_msg = "path should be 5 - 20 characters"
    %__MODULE__{}
    |> Ecto.Changeset.cast(attrs, [:room_name, :player_uuid, :player_name])
    |> Ecto.Changeset.update_change(:player_name, &String.trim/1)
    |> Ecto.Changeset.validate_required([:player_name, :room_name, :player_uuid])
    |> Ecto.Changeset.validate_length(:player_name, min: 2, max: 15)
    # TODO can these 2 be combined?
    |> Ecto.Changeset.validate_length(:room_name, min: 5, message: path_len_msg)
    |> Ecto.Changeset.validate_length(:room_name, max: 20, message: path_len_msg)
  end

  def validate(attrs) do
    changeset = changeset(attrs)
    if changeset.valid? do
      join_room = Ecto.Changeset.apply_changes(changeset)
      {:ok, join_room}
    else
      {:error, changeset}
    end
  end

end
