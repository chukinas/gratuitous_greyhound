defmodule Dreadnought.Multiplayer.Mission do

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.MissionHelpers

  # *** *******************************
  # *** CONSTRUCTORS

  # TODO the homepage needs this too
  def new(mission_name) when is_binary(mission_name) do
    {grid, margin} = MissionHelpers.medium_map()
    Mission.new(new_mission_spec(__MODULE__, mission_name), grid, margin)
    |> Map.put(:islands, MissionHelpers.islands())
    # Still needs players, units, and needs to be started
  end

end
