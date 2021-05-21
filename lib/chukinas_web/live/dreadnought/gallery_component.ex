alias Chukinas.Dreadnought.{Spritesheet, Sprite, Animation}
alias Chukinas.Geometry.Pose
alias ChukinasWeb.DreadnoughtView

defmodule ChukinasWeb.Dreadnought.GalleryComponent do
  use ChukinasWeb, :live_component

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def render(assigns) do
    DreadnoughtView.render("component_sprites.html", assigns)
  end

  @impl true
  def mount(socket) do
    sprites =
      Spritesheet.all()
      |> Enum.map(& Sprite.scale(&1, 2))
    animations = [
      Animation.Build.simple_muzzle_flash(Pose.origin()),
      Animation.Build.large_muzzle_flash(Pose.origin())
    ]
    |> Enum.map(&Animation.repeat/1)
    |> Enum.map(fn ani -> %{struct: ani, rect: Animation.bounding_rect(ani)} end)
    socket =
      socket
      |> assign(sprites: sprites, animations: animations)
      |> set_marker_visibility(false)
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket = assign(socket, show_markers?: !socket.assigns.show_markers?)
    {:noreply, socket}
  end

  # *** *******************************
  # *** FUNCTIONS

  def tabs do
    # TODO private?
    [
      %{title: "Play", route: "play", current?: false},
      %{title: "Sprites", route: "sprites", current?: true},
    ]
  end

  defp set_marker_visibility(socket, show_markers?) do
    assign(socket,
      show_markers?: show_markers?
    )
  end
end