defmodule DreadnoughtWeb.GalleryComponent do

  use DreadnoughtWeb, :live_component
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.BoundingRect
  alias Dreadnought.Core.Animations
  alias Dreadnought.Core.Sprites


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
  # *** HANDLE_EVENT

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket
    |> assign(show_markers?: !socket.assigns[:show_markers?])
    |> noreply
  end

  # *** *******************************
  # *** HELPERS

  defp render_markers_toggle(show_markers?, target) do
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
        x when x > 200 -> 3
        x when x > 100 -> 2
        _ -> 1
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
      rowspan: (if rect.height > 45, do: 1, else: 1)
    }
  end

end