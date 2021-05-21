# TODO rename
alias Chukinas.Dreadnought.{Spritesheet}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def render(assigns) do
    DreadnoughtView.render("layout_menu.html", assigns)
  end

  def render_template(template, assigns) do
    DreadnoughtView.render(template, assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    sprites =
      ~w(ship_large ship_small turret1 turret2 shell1 shell2 muzzle_flash)
      |> Enum.map(&Spritesheet.red/1)
    socket = assign(socket,
      page_title: "Dreadnought Resources",
      tabs: tabs(),
      header: "Sprites",
      show_markers?: true,
      sprites: sprites
    )
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket = case socket.assigns.live_action do
      nil -> redirect(socket, to: "/dreadnought/play")
        _ -> socket
    end
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket = assign(socket, show_markers?: !socket.assigns.show_markers?)
    {:noreply, socket}
  end

  def tabs do
    [
      %{title: "Play", route: "play", current?: false},
      %{title: "Sprites", route: "sprites", current?: true},
    ]
  end
end
