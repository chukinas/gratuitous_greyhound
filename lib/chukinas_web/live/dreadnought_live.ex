defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView

  #@impl true
  #def render(assigns) do
  #  DreadnoughtView.render("layout_menu.html", assigns)
  #end

  def render_template(template, assigns) do
    DreadnoughtView.render(template, assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "dreadnought_menu.html"}}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = case socket.assigns.live_action do
      nil -> redirect(socket, to: "/dreadnought/play")
        _ -> socket
    end
    socket = case {params, socket.assigns} do
      {%{"room" => room}, _} -> assign(socket, room: room, room_name: ChukinasWeb.Plugs.SanitizeRoomName.unslugify(room))
      {_, %{room: _room}} -> socket
      _ -> assign(socket, room: nil, room_name: nil)
    end
    |> IOP.inspect("dread live params")
    |> standard_assigns
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket = assign(socket, show_markers?: !socket.assigns.show_markers?)
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
    JoinRoom.validate(%{}) |> IOP.inspect("dread live std assign")
    assign(socket,
      tabs: tabs,
      page_title: page_title,
      header: if(active_tab.show_header, do: title, else: nil)
    )
  end
end


defmodule JoinRoom do
  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  def validate(params) do
    data  = %{}
    types = %{first_name: :string, last_name: :string, email: :string}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      #|> validate_required(...)
      #|> validate_length(...)
    changeset
  end
end
