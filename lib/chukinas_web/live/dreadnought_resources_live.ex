# TODO rename
alias Chukinas.Dreadnought.{Spritesheet}

defmodule ChukinasWeb.DreadnoughtResourcesLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def render(assigns) do
    DreadnoughtView.render("layout.html", assigns)
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
  def handle_event("toggle_show_markers", _, socket) do
    socket = assign(socket, show_markers?: !socket.assigns.show_markers?)
    {:noreply, socket}
  end

  def tabs do
    [
      %{title: "Welcome", route: "welcome", current?: false},
      %{title: "Play", route: "play", current?: false},
      %{title: "Sprites", route: "sprites", current?: true},
    ]
  end
end
