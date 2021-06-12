alias Chukinas.Sessions
alias ChukinasWeb.DreadnoughtLive.Impl

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = if socket.connected? do
      uuid = Map.fetch!(session, "uuid")
      socket
      |> assign(user: Sessions.new_user())
      |> assign(uuid: uuid)
      |> assign(room: Sessions.get_room_from_player_uuid(uuid))
    else
      socket
    end
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_menu.html"}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = case socket.assigns.live_action do
      nil ->
        path = Routes.dreadnought_path(socket, :room)
        send self(), {:push_patch, path}
        socket
      _ ->
        socket
        |> Impl.assign_room_param(params)
        |> Impl.standard_assigns
        |> assign(path_params: params)
    end
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket =
      socket
      |> assign(show_markers?: !socket.assigns[:show_markers?])
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
    socket = assign(socket, room: room)
    {:noreply, socket}
  end

end
