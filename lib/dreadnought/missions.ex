defmodule Dreadnought.Missions do

  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.Mission
  alias Dreadnought.Missions
  alias Dreadnought.Sessions.Players

  alias Dreadnought.Core.Player
  alias Dreadnought.Missions.DynamicSupervisor, as: MissionDynamicSupervisor
  alias Dreadnought.Missions.Registry, as: MissionRegistry

  # *** *******************************
  # *** API

  def add_player(%Player{mission_name: mission_name} = player) do
    # TODO use with stmt
    :ok = call_mission_server(mission_name, {:add_player, player})
    :ok = Players.set_room(player)
    :ok
  end

  def drop_player(player_uuid) do
    room_name = Players.get_room_name(player_uuid)
    # TODO rename drop_player
    Players.leave_room(player_uuid)
    cast_mission_server(room_name, {:drop_player, player_uuid})
  end

  # TODO rename get_by_mission_name
  def get(room_name) when is_binary(room_name) do
    call_mission_server room_name, :get
  end

  # TODO reanme get_by_player_uuid
  def get_mission_from_player_uuid(player_uuid) do
    with {:ok, room_name} <- Players.fetch_room_name(player_uuid),
         {:ok, room}      <- Missions.fetch(room_name) do
      room
    else
      _response ->
        nil
    end
  end

  def fetch(room_name) do
    case get(room_name) do
      nil -> :error
      room -> {:ok, room}
    end
  end

  def toggle_ready(room_name, player_id) when is_integer(player_id) do
    cast_mission_server room_name, {:toggle_ready, player_id}
  end

  def update_then_send_all(room_name, fun) do
    cast_mission_server room_name, {:update_then_send_all, fun}
  end

  def complete_player_turn(room_name, %ActionSelection{} = action_selection) do
    fun = &Mission.put(&1, action_selection)
    Missions.update_then_send_all(room_name, fun)
  end

  # *** *******************************
  # *** PRIVATE

  defp call_mission_server(room_name, msg) do
    room_name
    |> room_pid_from_name
    |> GenServer.call(msg)
  end

  defp cast_mission_server(room_name, msg) do
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
