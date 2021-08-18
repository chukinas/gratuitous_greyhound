# TODO rename Player?
defmodule Dreadnought.Multiplayer.NewPlayer do

  use Ecto.Schema
  @primary_key false

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Player
  alias Dreadnought.Multiplayer.MissionBuilder
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

  def to_player(%__MODULE__{mission_name: mission_name} = new_player) do
    new_player
    |> Map.from_struct
    |> Map.drop([:mission_name])
    |> Map.put(:mission_spec, MissionBuilder.mission_spec(mission_name))
    |> Player.from_new_player
  end

end
