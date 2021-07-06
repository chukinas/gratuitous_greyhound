defmodule ChukinasWeb.DreadnoughtPlayLive do

  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Sessions.Room
  import ChukinasWeb.DreadnoughtLive, only: [assign_uuid_and_room: 2]
  alias ChukinasWeb.DreadnoughtPlayView, as: View

  def render(template, assigns), do: View.render(template, assigns)

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_uuid_and_room(session)
      |> maybe_redirect_to_setup
      |> assign_mission
      |> assign_world_rect_and_islands
      |> assign_relative_arena_rect
      |> assign(page_title: "Dreadnought Play")
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_play.html"}}
  end

  def maybe_redirect_to_setup(socket) do
    if not Room.mission_in_progress?(socket.assigns.room) do
      path = Routes.dreadnought_path(socket, :setup)
      send self(), {:push_redirect, path}
    end
    socket
  end

  def assign_mission(socket) do
    with %Room{} = room <- socket.assigns.room,
         %Mission{} = mission <- Room.mission(room) do
      socket
      |> assign(mission: mission)
    else
      _ -> assign(socket, mission: nil)
    end
  end

  def assign_world_rect_and_islands(socket) do
    mission = socket.assigns.mission
    assign socket,
      world_rect: Mission.rect(mission) |> IOP.inspect("DreadnoughtPlayLive assign_world_rect_and_islands"),
      islands: Mission.islands(mission)
  end

  def assign_relative_arena_rect(socket) do
    assign socket,
      rel_arena_rect: Mission.arena_rect_wrt_world(socket.assigns.mission)
  end

  @impl true
  def handle_info({:push_redirect, path}, socket) do
    socket =
      socket
      |> push_redirect(to: path)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_room, room}, socket) do
    IOP.inspect room, "DreadnoughtPlayLive handle_info update_room"
    {:noreply, assign(
      socket,
      room: room
    ) |> assign_mission |> IOP.inspect("DreadnoughtPlayLive update_room")}
  end

end
