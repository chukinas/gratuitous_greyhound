alias Chukinas.Sessions

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    IOP.inspect params, "dread live mount"
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
        |> assign_room_param(params)
        |> standard_assigns
        |> assign(path_params: params)
    end
    {:noreply, socket}
  end

  def assign_room_param(socket, %{"room" => room}), do: assign(socket, room_param: room)
  def assign_room_param(socket, _params), do: assign(socket, room_param: nil)

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
      %{
        title: "Play",
        path: Sessions.path(socket, socket.assigns[:user_session]),
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
