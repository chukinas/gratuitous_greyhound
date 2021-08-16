defmodule Dreadnought.Multiplayer.Mission do

  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.MissionBuilder

  # *** *******************************
  # *** CONSTRUCTORS

  def new(mission_name) when is_binary(mission_name) do
    {grid, margin} = MissionBuilder.medium_map()
    Mission.new(mission_name, grid, margin)
    |> Map.put(:islands, MissionBuilder.islands())
    # Still needs players, units, and needs to be started
  end

end
