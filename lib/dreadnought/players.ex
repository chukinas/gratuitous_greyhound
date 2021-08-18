defmodule Dreadnought.Players do

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Player
  alias Dreadnought.Players.MissionNameRegistry
  alias Dreadnought.Players.ProcessRegistry

  # TODO rename `send_mission`
  def send_room(player_uuid, room) do
    for pid <- ProcessRegistry.pids(player_uuid) do
      send pid, {:update_mission, room}
    end
  end

  @doc"""
  Subscribe a LiveView to a Player UUID.
  """
  def register_liveview(player_uuid) do
    ProcessRegistry.register(player_uuid)
  end

  def register_mission_name(%Player{uuid: player_uuid, mission_spec: mission_spec}) do
    MissionNameRegistry.register(player_uuid, mission_spec)
  end

  @spec fetch_mission_spec(String.t) :: {:ok, mission_spec} | :error
  def fetch_mission_spec(player_uuid) when is_binary(player_uuid) do
    # TODO rename MissionIdRegistry
    MissionNameRegistry.fetch(player_uuid)
  end

  def drop_player(player_uuid) when is_binary(player_uuid) do
    MissionNameRegistry.delete(player_uuid)
  end

end
