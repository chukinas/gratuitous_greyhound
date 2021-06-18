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
  # *** GETTERS /1

  def name(%__MODULE__{name: value}), do: value

  def pretty_name(%__MODULE__{pretty_name: value}), do: value

  def players(%__MODULE__{players: value}), do: value

  def players_sorted(room) do
    room
    |> players
    |> Enum.sort_by(&Player.id/1, :asc)
  end

  def player_count(room) do
    room
    |> players
    |> Enum.count
  end

  def empty?(room) do
    player_count(room) == 0
  end

  def player_uuids(room) do
    for player <- players(room), do: Player.uuid(player)
  end

  # *** *******************************
  # *** GETTERS /2

  def players_except(room, unwanted_player_uuid) do
    room
    |> players
    |> Enum.filter(& !Player.has_uuid?(&1, unwanted_player_uuid))
  end

  def player_from_uuid(%__MODULE__{players: players}, wanted_player_uuid)
  when is_binary(wanted_player_uuid) do
    players
    |> Player.Enum.by_uuid(wanted_player_uuid)
  end

  def player_id_from_uuid(%__MODULE__{players: players}, wanted_player_uuid)
  when is_binary(wanted_player_uuid) do
    players
    |> Player.Enum.id_from_uuid(wanted_player_uuid)
  end

  # *** *******************************
  # *** API

  def add_player(room, player_uuid, player_name) do
    player_id = 1 + player_count(room)
    player = Player.new_human(player_id, player_uuid, player_name)
    room = Maps.push(room, :players, player)
    {:ok, room}
  end

  def remove_player(room, player_uuid) do
    room = %__MODULE__{room | players: players_except(room, player_uuid)}
    if empty?(room) do
      {:empty, room}
    else
      {:ok, room}
    end
  end

  def toggle_ready(%__MODULE__{} = room, player_id) do
    players = IdList.update!(room.players, player_id, &Player.toggle_ready/1)
    room = %__MODULE__{room | players: players}
    {:ok, room}
  end

end
