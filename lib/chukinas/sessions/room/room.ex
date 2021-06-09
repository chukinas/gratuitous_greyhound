alias Chukinas.Dreadnought.Player
alias Chukinas.Sessions.Room
alias Chukinas.Util.Maps

defmodule Room do
  use TypedStruct

  typedstruct do
    field :name, String.t, enforce: true
    field :players, [Player.t], default: []
  end

  # *** *******************************
  # *** NEW

  def new(room_name) do
    %__MODULE__{
      name: room_name
    }
  end

  # *** *******************************
  # *** GETTERS

  def players(%__MODULE__{players: value}), do: value

  def member_count(room) do
    room
    |> players
    |> Enum.count
  end

  # *** *******************************
  # *** API

  # TODO rename `add_player`?
  def add_member(room, player_uuid, player_name) do
    player_id = 1 + member_count(room)
    player = Player.new_human(player_id, player_uuid, player_name)
    room = Maps.push(room, :players, player)
           |> IOP.inspect
    {:ok, player_id, room}
  end

  def print_members(room) do
    room
    |> players
    |> Enum.reverse
    |> Stream.with_index(1)
    |> Enum.each(fn {member_name, number} -> IO.puts("#{number}: #{member_name}") end)
    nil
  end

end
