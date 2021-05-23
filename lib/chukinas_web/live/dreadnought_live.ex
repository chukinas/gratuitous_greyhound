defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  # TODO find a better home for UserSession
  alias Chukinas.Dreadnought.UserSession

  #@impl true
  #def render(assigns) do
  #  DreadnoughtView.render("layout_menu.html", assigns)
  #end

  def render_template(template, assigns) do
    DreadnoughtView.render(template, assigns)
  end

  @impl true
  def mount(params, _session, socket) do
    IOP.inspect params, "dread live mount"
    # TODO if mounted
    {_, user_session} = UserSession.empty()
    socket =
      socket
      |> assign(user_session: user_session)
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_menu.html"}}
  end

  @impl true
  def handle_params(params, url, socket) do
    IOP.inspect params, "dread live handle params"
    IOP.inspect url, "dread live handle params"
    socket = case socket.assigns.live_action do
      nil -> redirect(socket, to: "/dreadnought/play")
        _ -> socket
    end
    socket = case {params, socket.assigns} do
      {%{"room" => room}, _} -> assign(socket, room: room, room_name: ChukinasWeb.Plugs.SanitizeRoomName.unslugify(room))
      {_, %{room: _room}} -> socket
      _ -> assign(socket, room: nil, room_name: nil)
    end
    |> standard_assigns
    {:noreply, socket}
  end

  @impl true
  # TODO move this to....
  def handle_event("toggle_show_markers", _, socket) do
    socket = assign(socket, show_markers?: !socket.assigns.show_markers?)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:push_patch, opts}, socket) do
    IOP.inspect socket, "dread live push patch"
    socket = push_patch(socket, opts)
    {:noreply, socket}
  end

  def standard_assigns(socket) do
    live_action = socket.assigns.live_action
    tabs = [
      %{title: "Play", live_action: :play, current?: false, show_header: false},
      %{title: "Gallery", live_action: :gallery, current?: false, show_header: true},
    ]
    |> Enum.map(fn tab ->
      case tab.live_action do
        ^live_action -> %{tab | current?: true}
        _ -> %{tab | current?: false}
      end
    end)
    active_tab = Enum.find(tabs, & &1.live_action == live_action)
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
