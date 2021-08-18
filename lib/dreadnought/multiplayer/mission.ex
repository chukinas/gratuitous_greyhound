defmodule Dreadnought.Multiplayer.MissionBuilder do

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Builder, as: MissionBuilder
  # TODO rename Mission.Helpers
  alias Dreadnought.Core.MissionHelpers

  @behaviour MissionBuilder

  # *** *******************************
  # *** CONSTRUCTORS

  # TODO the homepage needs this too
  @impl MissionBuilder
  def new(mission_name) when is_binary(mission_name) do
    {grid, margin} = MissionHelpers.medium_map()
    Mission.new(mission_spec(mission_name), grid, margin)
    |> Map.put(:islands, MissionHelpers.islands())
    # Still needs players, units, and needs to be started
  end

  @impl MissionBuilder
  def mission_spec(mission_name) when is_binary(mission_name) do
    new_mission_spec(__MODULE__, mission_name)
  end

end
