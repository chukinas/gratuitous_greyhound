# TODO rename file

alias Chukinas.Sessions.User

defmodule User do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: false do
    field :uuid, String.t()
    field :name, String.t()
    field :room_name, String.t()
    field :pretty_room_name, String.t()
    field :player_id, integer
  end

  # *** *******************************
  # *** NEW

  def new() do
    %__MODULE__{
      uuid: Ecto.UUID.generate()
    }
  end

  # *** *******************************
  # *** GETTERS

  def uuid(%__MODULE__{uuid: value}), do: value

  def room_name(%__MODULE__{room_name: value}), do: value

  def pretty_room_name(%__MODULE__{pretty_room_name: value}), do: value

end
