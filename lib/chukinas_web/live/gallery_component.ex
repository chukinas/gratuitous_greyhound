defmodule ChukinasWeb.GalleryComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  alias Chukinas.BoundingRect
  alias Chukinas.Dreadnought.Animations
  alias Chukinas.Dreadnought.Sprites


  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Sprites.all()
      |> Enum.map(& Sprites.scale(&1, 2))
    animations =
      [
        Animations.simple_muzzle_flash(pose_origin()),
        Animations.large_muzzle_flash(pose_origin())
      ]
      |> Enum.map(&Animations.repeat/1)
    socket =
      socket
      |> assign(sprites_and_animations: Enum.map(animations ++ sprites, &wrap_item/1))
    {:ok, socket}
  end

  # *** *******************************
  # *** HELPERS

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

  defp wrap_item(item) do
    %{
      item: item,
      rect: BoundingRect.of(item) |> position_flip
    }
  end

end
