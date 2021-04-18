alias Chukinas.Dreadnought.{Mission, MissionBuilder, ActionSelection}

defmodule Chukinas.Dreadnought.State do
  use Agent

  def start_link do
    mission = MissionBuilder.build()
    Agent.start_link(fn -> mission end, name: __MODULE__)
    mission
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def complete_player_turn(%ActionSelection{} = action_selection) do
    mission =
      Agent.get(__MODULE__, & &1)
      |> Mission.complete_player_turn(action_selection)
    Agent.update(__MODULE__, fn _ -> mission end)
    Mission.to_player(mission)
  end
end
