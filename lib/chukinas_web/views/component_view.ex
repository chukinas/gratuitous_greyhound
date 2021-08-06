defmodule ChukinasWeb.ComponentView do

  use ChukinasWeb, :view
  use Chukinas.PositionOrientationSize
  alias Chukinas.Geometry.Rect

  def render_gsap_import, do: render("gsap_import.html", [])

  def render_toggle(id, label, selected?, attrs \\ []) do
    assigns =
      [
        id: id,
        label: label,
        selected?: selected?,
        attrs: attrs
      ]
    render("toggle.html", assigns)
  end

  def render_rotation_center_dot do
    render_dot(position_origin(), "pink")
  end

  def render_mount_dot(position) when has_position(position) do
    render_dot(position, "blue")
  end

  defp render_dot(position, color) do
    render("mount_dot.html",
      rect: Rect.from_centered_square(position, 20),
      color: color
    )
  end

end
