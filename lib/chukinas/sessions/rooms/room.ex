defmodule Chukinas.Sessions.Room do

  use TypedStruct
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions.RoomName
  alias Chukinas.Util.Maps
  alias Chukinas.Util.IdList

  typedstruct enforce: true do
    field :name, String.t
    field :pretty_name, String.t
    # TODO move players fully into mission
    field :players, [Player.t], default: []
    field :mission, Mission.t, enforce: false
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

  defp ready?(room) do
    room
    |> players
    |> Enum.all?(&Player.ready?/1)
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
  # *** SETTERS

  def update_players(%__MODULE__{players: players} = room, fun) do
    %__MODULE__{room | players: fun.(players)}
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
    player_update =
      fn players ->
        IdList.update!(players, player_id, &Player.toggle_ready/1)
      end
    room =
      room
      |> update_players(player_update)
      |> maybe_start_game
    {:ok, room}
  end

  # *** *******************************
  # *** PRIVATE

  defp maybe_start_game(room) do
    if ready?(room) do
      [player] = room |> players
      %__MODULE__{room | mission: MissionBuilder.online(player)}
    else
      room
    end
  end

end
