defmodule Chukinas.Dreadnought.Player do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :type, :human | :ai
    field :uuid, String.t
    field :name, String.t
  end

  # *** *******************************
  # *** NEW

  defp new(id, type, uuid, name) when type in ~w(human ai)a do
    %__MODULE__{
      id: id,
      type: type,
      uuid: uuid,
      name: name
    }
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

end
