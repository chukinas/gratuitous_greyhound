alias Chukinas.Sessions
alias ChukinasWeb.DreadnoughtLive.Impl

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    IO.puts "mounting!!"
    uuid = Map.fetch!(session, "uuid")
    socket =
      if !socket.connected? do
        socket
        |> assign(uuid: uuid)
        |> assign(room: nil)
      else
        Sessions.register_uuid(uuid)
        socket
        # TODO don't assign user here. User is no longer needed?
        |> assign(user: Sessions.new_user())
        |> assign(uuid: uuid)
        |> assign(room: Sessions.get_room_from_player_uuid(uuid))
      end
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_menu.html"}}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    IO.puts "handling params!!"
    play_or_join = if socket.assigns.room, do: :play, else: :join
    socket =
      case socket.assigns.live_action do
        :gallery ->
          socket
        ^play_or_join ->
          socket
        _wrong_live_action ->
          redirect_path = Routes.dreadnought_path(socket, play_or_join)
          send self(), {:push_patch, redirect_path}
          socket
      end
      |> Impl.standard_assigns
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
  def handle_info({:push_patch, path}, socket) do
    socket =
      socket
      |> push_patch(to: path)
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
      socket
      |> assign(room: room)
      |> Impl.maybe_redirect_to_play(room)
    {:noreply, socket}
  end

end
