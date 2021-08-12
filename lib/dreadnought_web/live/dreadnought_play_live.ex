defmodule DreadnoughtWeb.DreadnoughtPlayLive do

  use DreadnoughtWeb.DreadnoughtLiveViewHelpers, :play
  alias DreadnoughtWeb.DreadnoughtPlayView, as: View

  def render(template, assigns), do: View.render(template, assigns)

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_uuid_and_mission(session)
      |> maybe_redirect_to_setup
      |> assign_world_rect_and_islands
      |> assign_page_title
    {:ok, socket, layout: {DreadnoughtWeb.LayoutView, "dreadnought_play.html"}}
  end

  # *** *******************************
  # *** REDUCERS

  def assign_world_rect_and_islands(socket) do
    mission = socket.assigns.mission
    assign socket,
      rel_arena_rect: Mission.arena_rect_wrt_world(mission),
      world_rect: Mission.rect(mission),
      islands: Mission.islands(mission)
  end

end
