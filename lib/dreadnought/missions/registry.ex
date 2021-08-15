defmodule Dreadnought.Missions.Registry do

  @me Registry.Missions

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  # TODO rename build_server_name
  def build_name(mission_name) do
    {:via, Registry, {@me, mission_name}}
  end

  # TODO rename get_pid
  def pid(mission_name) do
    case Registry.lookup(@me, mission_name) do
      [] -> nil
      [{pid, _value} | _tail] -> pid
    end
  end

  @spec fetch_pid(String.t) :: :error | {:ok, pid}
  def fetch_pid(mission_name) do
    case pid(mission_name) do
      nil -> :error
      pid -> {:ok, pid}
    end
  end

end
