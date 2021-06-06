alias Chukinas.Sessions.UserSession
alias Chukinas.Sessions.RoomName

defmodule UserSession do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct do
    field :username, String.t()
    field :room, String.t()
    field :pretty_room_name, String.t()
  end

  # *** *******************************
  # *** NEW

  def new(username, room) do
    %__MODULE__{
      username: username,
      room: room,
      pretty_room_name: RoomName.pretty(room)
    }
  end

  # *** *******************************
  # *** GETTERS

  def username(%__MODULE__{username: value}), do: value

  def room(%__MODULE__{room: value}), do: value

  def pretty_room_name(%__MODULE__{pretty_room_name: value}), do: value

end
