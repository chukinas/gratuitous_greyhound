defmodule ChukinasWeb.GalleryComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Animations
  alias Chukinas.Dreadnought.Sprites


  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Sprites.all()
      |> Enum.map(& Sprites.scale(&1, 2))
    animations = [
      Animations.simple_muzzle_flash(pose_origin()),
      Animations.large_muzzle_flash(pose_origin())
    ]
    |> Enum.map(&map_animation/1)
    socket =
      socket
      |> assign(sprites: sprites, animations: animations)
    {:ok, socket}
  end

  # *** *******************************
  # *** HELPERS

  defp map_animation(animation) do
    %{
      struct: Animations.repeat(animation),
      rect: Animations.bounding_rect(animation)
    }
  end

  defp render_markers_toggle(show_markers?) do
    label =
      if show_markers? do
        "Markers Shown"
      else
        "Markers Hidden"
      end
    attrs =
      [
        "phx-click": "toggle_show_markers"
      ]
    ChukinasWeb.ComponentView.render_toggle(
      "toggleShowMarkers",
      label,
      show_markers?,
      attrs
    )
  end

end
