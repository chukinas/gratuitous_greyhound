defmodule Dreadnought.Core.Player do

  use TypedStruct
  use Dreadnought.Core.Mission.Spec

  # *** *******************************
  # *** TYPES

  typedstruct enforce: false do
    field :id, integer | nil, default: nil
    field :type, :human | :ai
    field :uuid, String.t
    field :name, String.t
    field :mission_spec, mission_spec
    field :ready?, boolean, default: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  # TODO These need to take a mission_spec?
  def new_ai(id, uuid, name) do
    new(id, :ai, uuid, name)
  end

  def new_manual(id) do
    new(id, :human, "", "")
  end

  def new_human(id, uuid, name) do
    new(id, :human, uuid, name)
  end

  def from_new_player(%{
      uuid: _uuid,
      name: _name,
      mission_spec: _mission_spec} = new_player) do
    player =
      new_player
      |> Map.put(:type, :human)
    struct!(__MODULE__, player)
  end

  # *** *******************************
  # *** PRIVATE CONSTRUCTORS

  defp new(id, type, uuid, name) when type in ~w(human ai)a do
    %__MODULE__{
      id: id,
      type: type,
      uuid: uuid,
      name: name,
    }
  end

  # *** *******************************
  # *** REDUCERS

  def put_id(player, id), do: %__MODULE__{player | id: id}

  def toggle_ready(%__MODULE__{ready?: ready?} = player) do
    %__MODULE__{player | ready?: !ready?}
  end

  # *** *******************************
  # *** CONVERTERS

  def ai?(%__MODULE__{type: type}), do: type === :ai

  def has_uuid?(%__MODULE__{uuid: uuid}, wanted_uuid) do
    uuid == wanted_uuid
  end

  def id(%__MODULE__{id: value}), do: value

  def name(%__MODULE__{name: value}), do: value

  def ready?(%__MODULE__{ready?: value}), do: value

  def type(%__MODULE__{type: value}), do: value

  def uuid(%__MODULE__{uuid: value}), do: value

end

defmodule Dreadnought.Core.Player.Enum do
  alias Dreadnought.Core.Player

  def id_from_uuid(players, uuid) do
    players
    |> by_uuid(uuid)
    |> Player.id
  end

  def by_uuid(players, uuid) do
    Enum.find(players, & Player.uuid(&1) == uuid)
  end

  def exclude_uuid(players, uuid) do
    Enum.filter(players, fn player -> !Player.has_uuid?(player, uuid) end)
  end

end
