defmodule DreadnoughtWeb.WorldLive do

  use DreadnoughtWeb, :live_view
  use Dreadnought.Core.Mission.Builder
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Helpers

  # *** *******************************
  # *** MOUNT, PARAMS

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket,
      mission: build("world"),
      width: 300,
      height: 300
    )
    {:ok, socket}
  end

  # *** *******************************
  # *** HELPERS

  def build(mission_name) do
    {grid, margin} = Helpers.small_map()
    mission_spec = mission_spec(mission_name)
    Mission.new(mission_spec, grid, margin)
    #|> Map.put(:islands, Helpers.islands())
  end

end
