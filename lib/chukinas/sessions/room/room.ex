alias Chukinas.Dreadnought.Player
alias Chukinas.Sessions.Room
alias Chukinas.Sessions.RoomName
alias Chukinas.Util.Maps

defmodule Room do
  use TypedStruct

  typedstruct do
    field :name, String.t, enforce: true
    field :pretty_name, String.t, enforce: true
    field :players, [Player.t], default: []
  end

  # *** *******************************
  # *** NEW

  def new(room_name) do
    %__MODULE__{
      name: room_name,
      pretty_name: RoomName.pretty(room_name)
    }
  end

  # *** *******************************
  # *** GETTERS

  def name(%__MODULE__{name: value}), do: value

  def pretty_name(%__MODULE__{pretty_name: value}), do: value

  def players(%__MODULE__{players: value}), do: value

  def players_sorted(room) do
    room
    |> players
    |> Enum.sort_by(&Player.id/1, :asc)
  end

  def member_count(room) do
    room
    |> players
    |> Enum.count
  end

  def player_uuids(room) do
    for player <- players(room), do: Player.uuid(player)
  end

  # *** *******************************
  # *** API

  def add_player(room, player_uuid, player_name) do
    player_id = 1 + member_count(room)
    player = Player.new_human(player_id, player_uuid, player_name)
    room = Maps.push(room, :players, player)
           |> IOP.inspect
    {:ok, player_id, room}
  end

end
