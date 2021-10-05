defmodule DreadnoughtWeb.GalleryComponent do

    use DreadnoughtWeb, :live_component
    use Spatial.PositionOrientationSize
    use Dreadnought.Sprite.Spec
  alias Spatial.BoundingRect
  alias Dreadnought.Core.Animations
  alias Dreadnought.Sprite
  alias DreadnoughtWeb.SvgView

  # *** *******************************
  # *** SETUP CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Sprite.Spec.all()
      |> Stream.map(&Sprite.Builder.build/1)
      |> Enum.map(& Sprite.scale(&1, 2))
    animations =
      [
        Animations.simple_muzzle_flash(pose_origin()),
        Animations.large_muzzle_flash(pose_origin())
      ]
      |> Enum.map(&Animations.repeat/1)
    socket =
      socket
      |> assign(sprites_and_animations: Enum.map(animations ++ sprites, &wrap_item/1))
      |> assign(sprite_specs: Spec.all())
    {:ok, socket}
  end

  # *** *******************************
  # *** HANDLER CALLBACKS

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket
    |> assign(show_markers?: !socket.assigns[:show_markers?])
    |> noreply
  end

  # *** *******************************
  # *** HELPERS

  defp _render_markers_toggle(show_markers?, target) do
    label =
      if show_markers? do
        "Markers Shown"
      else
        "Markers Hidden"
      end
    attrs =
      [
        "phx-click": "toggle_show_markers",
        "phx-target": target
      ]
    render_toggle(
      "toggleShowMarkers",
      label,
      show_markers?,
      attrs
    )
  end

  defp wrap_item(item) do
    rect = BoundingRect.of(item)
    colspan =
      case rect.width do
        x when x > 200 -> "col-span-3"
        x when x > 100 -> "col-span-2"
        _ -> "col-span-1"
      end
    mount_positions =
      case item do
        %{mounts: mounts} -> mounts
        _ -> []
      end
    %{
      item: item,
      rect: rect |> position_flip,
      mount_positions: mount_positions,
      colspan: colspan,
      rowspan: (if rect.height > 45, do: "row-span-1", else: "row-span-1")
    }
  end

end
