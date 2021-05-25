defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    IOP.inspect params, "dread live mount"
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_menu.html"}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IOP.inspect params, "dread live han params"
    socket = case route(params, socket) do
      {:ok, socket} ->
        socket
      {{:redirect, path}, socket} ->
        send self(), {:push_patch, path}
        socket
    end
    |> assign_room_param(params)
    |> standard_assigns
    |> assign(path_params: params)
    {:noreply, socket}
  end

  def assign_room_param(socket, %{"room" => room}), do: assign(socket, room_param: room)
  def assign_room_param(socket, _params), do: assign(socket, room_param: nil)

  # TODO simplify this?
  def route(params, socket) do
    route(params, socket, socket.assigns.live_action, socket.assigns[:user_session])
  end

  # /dreadnought -> /dreadnought/rooms
  def route(_params, socket, nil, _user_session) do
    path = Routes.dreadnought_path(socket, :room)
    {{:redirect, path}, socket}
  end

  # /dreadnought/rooms ... ok!
  #def route(params, socket, :room, _user_session) when not is_map_key(params, "room") do
  #  {:ok, socket}
  #end

  # if room matches session...
  # /dreadnought/rooms/:room ... ok!
  # /dreadnought/rooms/:room/join -> /dreadnought/rooms/:room
  #def route(%{"room" => desired_room}, socket, live_action, %Sessions.UserSession{room: room})
  #when desired_room == room do
  #  case live_action do
  #    :room ->
  #      {:ok, socket}
  #    :join ->
  #      path = Routes.dreadnought_path(socket, :room, room)
  #      {{:redirect, path}, socket}
  #  end
  #end

  # At this point, user hasn't actually joined any room, so they're forced to the Join screen
  # /dreadnought/rooms/:validroom/join ... ok!
  # /dreadnought/rooms/:validroom -> /dreadnought/rooms/:validroom/join
  # /dreadnought/rooms/:invalidroom/join -> /dreadnought/rooms/:validroom/join
  # /dreadnought/rooms/:invalidroom -> /dreadnought/rooms/:validroom/join
  #def route(%{"room" => desired_room}, socket, live_action, _user_session) do
  #  case {Sessions.get_room_slug(desired_room), live_action} do
  #    {^desired_room, :join} ->
  #      {:ok, socket}
  #    {room_slug, _live_action} ->
  #      path = Routes.dreadnought_path(socket, :join, room_slug)
  #      {{:redirect, path}, socket}
  #  end
  #end

  def route(_params, socket, _live_action, _user_session) do
    {:ok, socket}
  end

  @impl true
  def handle_info({:update_assigns, new_assigns}, socket) do
    new_assigns  |> IOP.inspect("dread live h.info update ass")
    socket =
      socket
      |> assign(new_assigns)
    {:noreply, socket}
  end

  def standard_assigns(socket) do
    gallery? = socket.assigns.live_action == :gallery
    tabs = [
      %{title: "Play", live_action: :room, current?: !gallery?, show_header: false},
      %{title: "Gallery", live_action: :gallery, current?: gallery?, show_header: true},
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
