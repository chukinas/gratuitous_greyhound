defmodule Dreadnought.Missions do

  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Missions.DynamicSupervisor, as: MissionDynamicSupervisor
  alias Dreadnought.Missions.Registry, as: MissionRegistry
  alias Dreadnought.Players

  # *** *******************************
  # *** API

  def add_player(%Player{mission_name: mission_name} = player) do
    with :ok <- call_mission_server(mission_name, {:add_player, player}),
         :ok <- Players.register_mission_name(player) do
      :ok
    end
  end

  def drop_player(player_uuid) do
    case Players.fetch_mission_name(player_uuid) do
      {:ok, mission_name} ->
        Players.drop_player(player_uuid)
        cast_mission_server(mission_name, {:drop_player, player_uuid})
        :ok
      :error ->
        :error
    end
  end

  def get_by_mission_name(mission_name) when is_binary(mission_name) do
    call_mission_server mission_name, :get
  end

  def get_by_player_uuid(player_uuid) do
    with {:ok, mission_name} <- Players.fetch_mission_name(player_uuid),
         {:ok, room}      <- fetch(mission_name) do
      room
    else
      _response ->
        nil
    end
  end

  def fetch(mission_name) do
    case get_by_mission_name(mission_name) do
      nil -> :error
      room -> {:ok, room}
    end
  end

  def toggle_ready(mission_name, player_id) when is_integer(player_id) do
    cast_mission_server mission_name, {:toggle_ready, player_id}
  end

  def update_then_send_all(mission_name, fun) do
    cast_mission_server mission_name, {:update_then_send_all, fun}
  end

  def complete_player_turn(mission_name, %ActionSelection{} = action_selection) do
    fun = &Mission.put(&1, action_selection)
    update_then_send_all(mission_name, fun)
  end

  # *** *******************************
  # *** PRIVATE

  defp call_mission_server(mission_name, msg) do
    mission_name
    |> room_pid_from_name
    |> GenServer.call(msg)
  end

  defp cast_mission_server(mission_name, msg) do
    mission_name
    |> room_pid_from_name
    |> GenServer.cast(msg)
  end

  defp room_pid_from_name(mission_name) when is_binary(mission_name) do
    with :error <- MissionRegistry.fetch_pid(mission_name),
         {:ok, pid} <- MissionDynamicSupervisor.new_room(mission_name) do
      pid
    else
      {:ok, pid} -> pid
    end
  end

end
