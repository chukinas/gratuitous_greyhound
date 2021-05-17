alias Chukinas.Dreadnought.{Mission, MissionBuilder, ActionSelection}

defmodule Chukinas.Dreadnought.State do
  use Agent

  def start_link do
    mission = MissionBuilder.dev()
    {:ok, pid} = Agent.start_link(fn -> mission end)
    {pid, mission}
  end

  def get(pid) do
    Agent.get(pid, & &1)
  end

  def complete_player_turn(pid, %ActionSelection{} = player_actions) do
    :ok = Agent.update(pid, & Mission.put(&1, player_actions))
    pid |> get |> Mission.to_player
  end
end
