defmodule Dreadnought.Missions.Registry do

  use Dreadnought.Core.Mission.Spec

  @me Registry.Missions

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  # TODO rename build_server_name
  def build_name(mission_spec) when is_mission_spec(mission_spec) do
    {:via, Registry, {@me, mission_spec}}
  end

  # TODO rename get_pid
  def pid(mission_spec) when is_mission_spec(mission_spec) do
    case Registry.lookup(@me, mission_spec) do
      [] -> nil
      [{pid, _value} | _tail] -> pid
    end
  end

  @spec fetch_pid(mission_spec) :: :error | {:ok, pid}
  def fetch_pid(mission_spec) when is_mission_spec(mission_spec) do
    case pid(mission_spec) do
      nil -> :error
      pid -> {:ok, pid}
    end
  end

end
