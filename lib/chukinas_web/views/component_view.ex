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

  def render_content_button(content, attrs \\ []) do
    class = "w-full flex justify-center rounded-md border-2 border-yellow-100 shadow-sm px-6 py-3 text-lg font-medium hover:bg-white/25 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
    Phoenix.HTML.Tag.content_tag :button, content, attrs ++ [class: class]
  end

end
