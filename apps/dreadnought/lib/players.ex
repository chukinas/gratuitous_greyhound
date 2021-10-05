defmodule Dreadnought.Players do

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.Mission
  alias Dreadnought.Players.MissionSpecRegistry
  alias Dreadnought.Players.ProcessRegistry

  def send_mission(player_uuid, %Mission{} = mission), do: do_send_mission(player_uuid, mission)
  def send_mission(player_uuid, nil), do: do_send_mission(player_uuid, nil)

  defp do_send_mission(player_uuid, mission_or_nil) do
    for pid <- ProcessRegistry.pids(player_uuid) do
      send pid, {:update_mission, mission_or_nil}
    end
  end

  @doc"""
  Subscribe a LiveView to a Player UUID.
  """
  def register_liveview(player_uuid) do
    ProcessRegistry.register(player_uuid)
  end

  def register_mission_name(%Player{uuid: player_uuid, mission_spec: mission_spec}) do
    MissionSpecRegistry.register(player_uuid, mission_spec)
  end

  @spec fetch_mission_spec(String.t) :: {:ok, mission_spec} | :error
  def fetch_mission_spec(player_uuid) when is_binary(player_uuid) do
    MissionSpecRegistry.fetch(player_uuid)
  end

  def drop_player(player_uuid) when is_binary(player_uuid) do
    MissionSpecRegistry.delete(player_uuid)
  end

end
