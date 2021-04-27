alias Chukinas.Dreadnought.{Mission, MissionBuilder, PlayerActions}

defmodule Chukinas.Dreadnought.State do
  use Agent

  def start_link do
    mission = MissionBuilder.build()
    {:ok, pid} = Agent.start_link(fn -> mission end)
    {pid, mission}
  end

  def get(pid) do
    Agent.get(pid, & &1)
  end

  def complete_player_turn(pid, %PlayerActions{} = player_actions) do
    :ok = Agent.update(pid, & Mission.complete_player_turn(&1, player_actions))
    pid |> get |> Mission.to_player
  end
end
