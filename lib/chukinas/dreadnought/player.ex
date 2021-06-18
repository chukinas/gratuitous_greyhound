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
  # *** NEW

  defp new(id, type, uuid, name) when type in ~w(human ai)a do
    %__MODULE__{
      id: id,
      type: type,
      uuid: uuid,
      name: name,
      ready?: false
    }
    |> IOP.inspect("Player new")
  end

  def new_human(id, uuid, name) do
    new(id, :human, uuid, name)
  end

  def new_ai(id, uuid, name) do
    new(id, :ai, uuid, name)
  end

  # *** *******************************
  # *** GETTERS

  def id(%__MODULE__{id: value}), do: value
  def type(%__MODULE__{type: value}), do: value
  def uuid(%__MODULE__{uuid: value}), do: value
  def name(%__MODULE__{name: value}), do: value
  def ai?(%__MODULE__{type: type}), do: type === :ai

  # *** *******************************
  # *** API

  def has_uuid?(%__MODULE__{uuid: uuid}, wanted_uuid) do
    uuid == wanted_uuid
  end

  def toggle_ready(%__MODULE__{ready?: ready?} = player) do
    %__MODULE__{player | ready?: !ready?}
  end

end

defmodule Chukinas.Dreadnought.Player.Enum do
  alias Chukinas.Dreadnought.Player
  def id_from_uuid(players, uuid) do
    players
    |> Enum.find(& Player.uuid(&1) == uuid)
    |> Player.id
  end
end
