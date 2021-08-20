defmodule DreadnoughtWeb.WorldLive do

  use DreadnoughtWeb, :live_view
  use Dreadnought.Core.Mission.Builder
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Helpers

  # *** *******************************
  # *** MOUNT, PARAMS

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        mission: build("world"),
        margin: 100,
        play_area_size: size_new(600, 400)
      )
      |> assign_board_size
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

  def assign_board_size(%{assigns: %{margin: margin, play_area_size: play_area_size}} = socket) do
    assign(socket, board_size: size_add(play_area_size, 2 * margin))
  end

end
