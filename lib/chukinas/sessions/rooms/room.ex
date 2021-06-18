defmodule Chukinas.Sessions.Room do

  use TypedStruct
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions.RoomName
  alias Chukinas.Util.Maps
  alias Chukinas.Util.IdList

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

  def remove_player(room, player_uuid) do
    %__MODULE__{room | players: players_except(room, player_uuid)}
  end

  def players_except(room, unwanted_player_uuid) do
    room
    |> players
    |> Enum.filter(& !Player.has_uuid?(&1, unwanted_player_uuid))
  end

  def player_id_from_uuid(%__MODULE__{players: players}, wanted_player_uuid)
  when is_binary(wanted_player_uuid) do
    players
    |> Player.Enum.id_from_uuid(wanted_player_uuid)
  end

  # *** *******************************
  # *** SETTERS

  def toggle_ready(%__MODULE__{} = room, player_id) do
    players = IdList.update!(room.players, player_id, &Player.toggle_ready/1)
    %__MODULE__{room | players: players}
  end

end
