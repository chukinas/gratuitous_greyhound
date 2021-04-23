alias Chukinas.Dreadnought.{Spritesheet, Sprite}
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
      Spritesheet.all()
      |> Enum.map(& Sprite.scale(&1, 2))
    socket =
      socket
      |> assign(sprites: sprites)
      |> set_marker_visibility(true)
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

  defp set_marker_visibility(socket, show_markers?) do
    sprites =
      socket.assigns.sprites
      |> fit_or_center_sprites(show_markers?)
    assign(socket,
      sprites: sprites,
      show_markers?: show_markers?
    )
  end

  defp fit_or_center_sprites(sprites, centered?) do
    fun = if centered?, do: :center, else: :fit
    Enum.map(sprites, & apply(Sprite, fun, [&1]))
  end
end
