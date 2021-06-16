# TODO rename?

defmodule Chukinas.Sessions.User do

  alias Chukinas.Dreadnought.Player

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: false do
    field :player_id, integer
    field :uuid, String.t(), enforce: true
    field :name, String.t()
    field :room_name, String.t()
    field :players, [Player.t]
  end

  # *** *******************************
  # *** NEW

  def new do
    new Ecto.UUID.generate()
  end

  def new(uuid) do
    %__MODULE__{
      uuid: uuid
    }
  end

  # *** *******************************
  # *** GETTERS

  def uuid(%__MODULE__{uuid: value}), do: value

  def name(%__MODULE__{name: value}), do: value

  def room_name(%__MODULE__{room_name: value}), do: value

end
