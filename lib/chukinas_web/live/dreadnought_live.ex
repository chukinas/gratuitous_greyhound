defmodule ChukinasWeb.DreadnoughtLive do

  use ChukinasWeb, :live_view
  alias Chukinas.Sessions
  alias Chukinas.Sessions.Room

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, session, socket) do
    uuid = Map.fetch!(session, "uuid")
    socket =
      if socket.connected? do
        Sessions.register_uuid(uuid)
        socket
        |> assign(uuid: uuid)
        |> assign(room: Sessions.get_room_from_player_uuid(uuid))
      else
        socket
        |> assign(uuid: uuid)
        |> assign(room: nil)
      end
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_menu.html"}}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    live_action = socket.assigns.live_action
    mission_in_progress? =
      case socket.assigns.room do
        nil -> false
        room -> Room.mission_in_progress?(room)
      end
    cond do
      live_action == :index ->
        Routes.dreadnought_path(socket, :setup) |> redirect
      mission_in_progress? ->
        path = Routes.dreadnought_play_path(socket, :index)
        send self(), {:push_redirect, path}
      true ->
        :ok
    end
    socket = standard_assigns(socket)
    {:noreply, socket}
  end

  def redirect(path) do
    send self(), {:push_patch, path}
  end

  # *** *******************************
  # *** CALLBACKS (EVENTS)

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket =
      socket
      |> assign(show_markers?: !socket.assigns[:show_markers?])
    {:noreply, socket}
  end

  @impl true
  def handle_event("leave_room", _, socket) do
    Sessions.leave_room(socket.assigns.uuid)
    {:noreply, socket}
  end

  # *** *******************************
  # *** CALLBACKS (INFO)

  @impl true
  def handle_info({:push_patch, path}, socket) do
    socket =
      socket
      |> push_patch(to: path)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:push_redirect, path}, socket) do
    socket =
      socket
      |> push_redirect(to: path)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_assigns, new_assigns}, socket) do
    socket =
      socket
      |> assign(new_assigns)
    {:noreply, socket}
  end

  # TODO does the user struct still need the room name, etc?
  @impl true
  def handle_info({:update_room, room}, socket) do
    socket =
      if Room.mission_in_progress?(room) do
        path = Routes.dreadnought_play_path(socket, :index)
        Phoenix.LiveView.push_redirect(socket, to: path)
      else
        socket
        |> assign(room: room)
      end
    {:noreply, socket}
  end

  # *** *******************************
  # *** FUNCTIONS

  def standard_assigns(socket) do
    gallery? = socket.assigns.live_action == :gallery
    tabs = [
      %{
        title: "Play",
        path: Routes.dreadnought_path(socket, :setup),
        current?: !gallery?,
        show_header: false
      },
      %{
        title: "Gallery",
        path: Routes.dreadnought_path(socket, :gallery),
        current?: gallery?,
        show_header: true
      },
    ]
    active_tab = Enum.find(tabs, & &1.current?)
    title = case active_tab do
      %{title: title} -> title
      nil -> nil
    end
    page_title = case title do
      nil -> "Dreadnought"
      title -> "Dreadnought | #{title}"
    end
    assign(socket,
      tabs: tabs,
      page_title: page_title,
      header: if(active_tab.show_header, do: title, else: nil)
    )
  end

end
