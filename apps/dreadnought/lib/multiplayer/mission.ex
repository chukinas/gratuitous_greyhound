defmodule Dreadnought.Multiplayer.Mission do

  use Dreadnought.Core.Mission.Builder
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Helpers

  # *** *******************************
  # *** CONSTRUCTORS

  # TODO the homepage needs this too
  @impl Builder
  def build(mission_name) when is_binary(mission_name) do
    {grid, margin} = Helpers.medium_map()
    Mission.new(mission_spec(mission_name), grid, margin)
    |> Map.put(:islands, Helpers.islands())
    # Still needs players, units, and needs to be started
  end

end
