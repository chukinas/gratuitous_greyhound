alias Chukinas.Dreadnought.{Spritesheet}
alias ChukinasWeb.DreadnoughtView

defmodule ChukinasWeb.Dreadnought.SpritesComponent do
  use ChukinasWeb, :live_component

  @impl true
  def render(assigns) do
    DreadnoughtView.render("sprites.html", assigns)
  end

  @impl true
  def mount(socket) do
    sprites =
      ~w(ship_large ship_small turret1 turret2 shell1 shell2 muzzle_flash)
      |> Enum.map(&Spritesheet.red/1)
    socket = assign(socket,
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
