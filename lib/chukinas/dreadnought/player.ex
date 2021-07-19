defmodule Chukinas.Dreadnought.Player do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :type, :human | :ai
    field :uuid, String.t
    field :name, String.t
    field :ready?, boolean
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new_ai(id, uuid, name) do
    new(id, :ai, uuid, name)
  end

  def new_manual(id) do
    new(id, :human, "", "")
  end

  def new_human(id, uuid, name) do
    new(id, :human, uuid, name)
  end

  # *** *******************************
  # *** PRIVATE CONSTRUCTORS

  defp new(id, type, uuid, name) when type in ~w(human ai)a do
    %__MODULE__{
      id: id,
      type: type,
      uuid: uuid,
      name: name,
      ready?: false
    }
  end

  # *** *******************************
  # *** REDUCERS

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

defmodule Chukinas.Dreadnought.Player.Enum do
  alias Chukinas.Dreadnought.Player

  def id_from_uuid(players, uuid) do
    players
    |> by_uuid(uuid)
    |> Player.id
  end

  def by_uuid(players, uuid) do
    Enum.find(players, & Player.uuid(&1) == uuid)
  end

end
