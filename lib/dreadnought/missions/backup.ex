defmodule Dreadnought.Missions.Backup do

  use Agent
  alias Dreadnought.Core.Mission

  def start_link(_init_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec put(Mission.t) :: :ok
  def put(%Mission{} = mission) do
    Agent.update(__MODULE__, &Map.put(&1, Mission.name(mission), mission))
  end

  @spec pop(String.t) :: Mission.t | nil
  def pop(room_name) do
    Agent.get_and_update(__MODULE__, &Map.pop(&1, room_name))
  end

  def fetch_and_pop(room_name) do
    case pop(room_name) do
      nil -> :error
      room -> {:ok, room}
    end
  end

end
