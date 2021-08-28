defmodule DreadnoughtWeb.WorldLive do

    use DreadnoughtWeb, :live_view
    use Dreadnought.Core.Mission.Builder
    use Dreadnought.Sprite.Spec
    use Spatial.PositionOrientationSize
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Mission.Helpers
  alias Dreadnought.Core.Unit
  alias Dreadnought.Core.UnitBuilder
  alias Dreadnought.Paths

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
      |> assign_unit
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

  def assign_unit(socket) do
    path = Paths.new_turn(pose_origin(), 300, 45)
    end_pose = Paths.get_end_pose(path)
    maneuver_event = Dreadnought.Core.Unit.Event.Maneuver.new(path)
    unit = UnitBuilder.build(:blue_dreadnought, 1, 1, end_pose, [])
           |> Unit.put(maneuver_event)
    socket
    |> assign(unit: unit)
  end

end
