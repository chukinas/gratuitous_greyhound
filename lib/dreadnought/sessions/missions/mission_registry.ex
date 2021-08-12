defmodule Dreadnought.Sessions.MissionRegistry do

  @me Registry.Missions

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  def build_name(room_name) do
    {:via, Registry, {@me, room_name}}
  end

  def pid(room_name) do
    case Registry.lookup(@me, room_name) do
      [] -> nil
      [{pid, _value} | _tail] -> pid
    end
  end

  @spec fetch_pid(String.t) :: :error | {:ok, pid}
  def fetch_pid(room_name) do
    case pid(room_name) do
      nil -> :error
      pid -> {:ok, pid}
    end
  end

end
