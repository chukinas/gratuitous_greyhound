# TODO rename Player?
defmodule Dreadnought.Multiplayer.NewPlayer do

  use Ecto.Schema
  @primary_key false

  alias Dreadnought.Util.Slugs
  alias Ecto.Changeset

  # *** *******************************
  # *** TYPES

  @types %{
    name: :string,
    uuid: :string,
    mission_name: :string
  }

  @required_fields Map.keys @types

  embedded_schema do
    for key <- Map.keys(@types) do
      Macro.escape(field(key, :string))
    end
  end

  @type t :: %__MODULE__{
    name: String.t,
    uuid: String.t,
    mission_name: String.t
  }

  # *** *******************************
  # *** API

  def changeset(%__MODULE__{} = player, attrs) do
    player
    |> Changeset.cast(attrs, @required_fields)
    |> Changeset.update_change(:name, &String.trim/1)
    |> Changeset.update_change(:mission_name, &Slugs.slugify_then_beautify/1)
    |> Changeset.validate_required(@required_fields)
    |> Changeset.validate_length(:name, min: 2, max: 15)
    |> Changeset.validate_length(:mission_name, min: 5, max: 20)
  end

  #def validate(data \\ %__MODULE__{}, attrs) do
  #  changeset = changeset(data, attrs)
  #  if changeset.valid? do
  #    join_room = Changeset.apply_changes(changeset)
  #    {:ok, join_room}
  #  else
  #    {:error, changeset}
  #  end
  #end

  # TODO if this ends up no longer being needed, remove from Player
  #def types, do: @types

end
