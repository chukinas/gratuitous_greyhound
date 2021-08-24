defmodule DreadnoughtWeb.WorldLive do

  use DreadnoughtWeb, :live_view
  use Dreadnought.Core.Mission.Builder
  use Dreadnought.PositionOrientationSize
  use Dreadnought.Sprite.Spec
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
      |> assign_posed_sprite
    {:ok, socket}
  end

  # *** *******************************
  # *** HELPERS

  def build(mission_name) do
    {grid, margin} = Helpers.small_map()
    mission_name
    |> mission_spec
    |> Mission.new(grid, margin)
    |> Mission.add_island_spec({:square, pose_new(200, 200, 30)})
  end

  def assign_board_size(%{assigns: %{margin: margin, play_area_size: play_area_size}} = socket) do
    assign(socket, board_size: size_add(play_area_size, 2 * margin))
  end

  def assign_posed_sprite(socket) do
    sprite_specs = [
      {:red, "ship_large"},
      {:blue, "hull_blue_small"}
    ]
    assign(socket, sprite_specs: sprite_specs)
  end

end
