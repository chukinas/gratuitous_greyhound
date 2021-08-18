defmodule Dreadnought.Missions.Backup do

  # TODO delete backups when the mission is terminated

  use Agent
  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Mission

  def start_link(_init_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec put(Mission.t) :: :ok
  def put(%Mission{} = mission) do
    Agent.update(__MODULE__, &Map.put(&1, Mission.mission_spec(mission), mission))
  end

  @spec pop(tuple) :: Mission.t | nil
  def pop(mission_spec) when is_mission_spec(mission_spec) do
    Agent.get_and_update(__MODULE__, &Map.pop(&1, mission_spec))
  end

  def fetch_and_pop(mission_spec) when is_mission_spec(mission_spec) do
    case pop(mission_spec) do
      nil -> :error
      mission -> {:ok, mission}
    end
  end

end
