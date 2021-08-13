defmodule Dreadnought.Sessions.Missions do

  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Sessions.MissionDynamicSupervisor
  alias Dreadnought.Multiplayer.NewPlayer
  alias Dreadnought.Sessions.MissionRegistry

  # *** *******************************
  # *** GETTERS

  # TODO delete these?
  def room_name(%NewPlayer{mission_name: value}), do: value

  def room_name(mission), do: Mission.name(mission)

  # *** *******************************
  # *** API

  def add_player(%Player{mission_name: mission_name} = player) do
    genserver_call(mission_name, {:add_player, player})
  end

  def drop_player(room_name, player_uuid) when is_binary(room_name) do
    genserver_cast(room_name, {:drop_player, player_uuid})
  end

  def get(room_name) when is_binary(room_name) do
    genserver_call room_name, :get
  end

  def fetch(room_name) do
    case get(room_name) do
      nil -> :error
      room -> {:ok, room}
    end
  end

  def toggle_ready(room_name, player_id) when is_integer(player_id) do
    genserver_cast room_name, {:toggle_ready, player_id}
  end

  def update_then_send_all(room_name, fun) do
    genserver_cast room_name, {:update_then_send_all, fun}
  end

  # *** *******************************
  # *** PRIVATE

  defp genserver_call(room_name, msg) do
    room_name
    |> room_pid_from_name
    |> GenServer.call(msg)
  end

  defp genserver_cast(room_name, msg) do
    room_name
    |> room_pid_from_name
    |> GenServer.cast(msg)
  end

  defp room_pid_from_name(room_name) when is_binary(room_name) do
    with :error <- MissionRegistry.fetch_pid(room_name),
         {:ok, pid} <- MissionDynamicSupervisor.new_room(room_name) do
      pid
    else
      {:ok, pid} -> pid
    end
  end

end
