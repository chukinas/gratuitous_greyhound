defmodule ChukinasWeb.DreadnoughtLive do

  use ChukinasWeb, :live_view
  alias Chukinas.Sessions
  alias Chukinas.Dreadnought.Mission

  # *** *******************************
  # *** MOUNT, PARAMS

  @impl true
  def mount(_params, session, socket) do
    socket = assign_uuid_and_mission(socket, session)
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "ocean.html"}}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    IOP.inspect self()
    if live_action?(socket, :setup) && mission_in_progress?(socket) do
      path = Routes.dreadnought_play_path(socket, :index)
      send self(), {:push_redirect, path}
    end
    header =
      case socket.assigns.live_action do
        :gallery -> "Gallery"
        _ -> "Dreadnought"
      end
    socket
    |> assign(header: header)
    |> noreply
  end

  # *** *******************************
  # *** HANDLE_EVENT

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket
    |> assign(show_markers?: !socket.assigns[:show_markers?])
    |> noreply
  end

  # *** *******************************
  # *** HANDLE_INFO

  @impl true
  def handle_info({:push_redirect, path}, socket) do
    socket =
      socket
      |> push_redirect(to: path)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_child_component, live_component, assigns}, socket) do
    send_update(live_component, assigns)
    {:noreply, socket}
  end

  # TODO does the user struct still need the room name, etc?
  @impl true
  def handle_info({:update_room, mission}, socket) do
    socket =
      if mission_in_progress?(mission) do
        path = Routes.dreadnought_play_path(socket, :index)
        Phoenix.LiveView.push_redirect(socket, to: path)
      else
        socket
        |> assign(mission: mission)
      end
    {:noreply, socket}
  end

  # *** *******************************
  # *** HELPERS

  @spec assign_uuid_and_mission(Phoenix.LiveView.Socket.t, map) :: Phoenix.LiveView.Socket.t
  def assign_uuid_and_mission(socket, session) do
    IOP.inspect self()
    uuid = Map.fetch!(session, "uuid")
    if socket.connected? do
      Sessions.register_uuid(uuid)
      socket
      |> assign(uuid: uuid)
      |> assign(mission: Sessions.get_mission_from_player_uuid(uuid))
    else
      socket
      |> assign(uuid: uuid)
      |> assign(mission: nil)
    end
  end

  # TODO this is ugly
  #def mission(nil), do: nil
  #def mission(%Mission{} = value), do: value
  def mission(socket), do: socket.assigns[:mission]

  def mission_in_progress?(socket) do
    with %Mission{} = mission <- mission(socket),
         true <- Mission.in_progress?(mission) do
      true
    else
      _ -> false
    end
  end

end
