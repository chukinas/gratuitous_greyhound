defmodule Chukinas.Sessions.Room do

  use TypedStruct
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions.RoomName
  alias Chukinas.Util.IdList

  typedstruct enforce: true do
    field :name, String.t
    field :pretty_name, String.t
    field :mission, Mission.t | %{}, default: %{players: []}
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

  def mission(%__MODULE__{mission: value}), do: value

  def name(%__MODULE__{name: value}), do: value

  def pretty_name(%__MODULE__{pretty_name: value}), do: value

  def players(%__MODULE__{mission: mission}) do
    Mission.players(mission)
  end

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

  def player_from_uuid(%__MODULE__{} = room, wanted_player_uuid)
  when is_binary(wanted_player_uuid) do
    room
    |> players
    |> Player.Enum.by_uuid(wanted_player_uuid)
  end

  def player_id_from_uuid(%__MODULE__{} = room, wanted_player_uuid)
  when is_binary(wanted_player_uuid) do
    room
    |> player_from_uuid(wanted_player_uuid)
    |> Player.id
  end

  # *** *******************************
  # *** SETTERS

  def put_mission(%__MODULE__{} = room, mission) do
    %__MODULE__{room | mission: mission}
  end

  def put_players(%__MODULE__{} = room, players) do
    mission = room.mission |> Mission.put(players)
    put_mission(room, mission)
  end

  def update_players(%__MODULE__{} = room, fun) do
    players =
      room
      |> players
      |> fun.()
    put_players(room, players)
  end

  # *** *******************************
  # *** API

  def add_player(room, player_uuid, player_name) do
    player_id = 1 + player_count(room)
    player = Player.new_human(player_id, player_uuid, player_name)
    mission =
      room
      |> mission
      |> Mission.put(player)
    room = put_mission(room, mission)
    {:ok, room}
  end

  def remove_player(room, player_uuid) do
    players = players_except(room, player_uuid)
    room = put_players(room, players)
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
