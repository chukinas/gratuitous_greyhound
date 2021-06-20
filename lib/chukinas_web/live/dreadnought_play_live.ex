defmodule ChukinasWeb.DreadnoughtPlayLive do

  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Mission
  # TODO refactor out this state module
  alias Chukinas.Dreadnought.State
  alias Chukinas.Sessions.Room
  alias ChukinasWeb.Dreadnought
  import ChukinasWeb.DreadnoughtLive, only: [assign_uuid_and_room: 2]

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def render(assigns) do
    # TODO get rid of this manual render
    ChukinasWeb.DreadnoughtView.render "layout_gameplay.html", assigns
  end

  @impl true
  def mount(_params, session, socket) do
    {pid, mission} = State.start_link()
    socket =
      socket
      |> assign_uuid_and_room(session)
      |> maybe_redirect_to_setup
      |> assign(
        # TODO add page titles to dreadnought_live too
        page_title: "Dreadnought",
        pid: pid,
        mission: mission,
        mission_playing_surface: Mission.to_playing_surface(mission) |> Map.from_struct,
        mission_player: Mission.to_player(mission)
      )
    {:ok, socket}
  end

  def maybe_redirect_to_setup(socket) do
    if not Room.mission_in_progress?(socket.assigns.room) do
      path = Routes.dreadnought_path(socket, :setup)
      send self(), {:push_redirect, path}
    end
    socket
  end

  @impl true
  def handle_event("log", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("route_to", %{"route" => route}, socket) do
    {:noreply, push_patch(socket, to: route)}
  end

  @impl true
  # TODO rename mission_player to `player_turn` PlayerTurn
  def handle_info({:player_turn_complete, player_actions}, socket) do
    mission_player = State.complete_player_turn(socket.assigns.pid, player_actions)
    send_update Dreadnought.DynamicWorldComponent, mission_player
    {:noreply, socket}
  end

  @impl true
  def handle_info({:push_redirect, path}, socket) do
    socket =
      socket
      |> push_redirect(to: path)
    {:noreply, socket}
  end

end
