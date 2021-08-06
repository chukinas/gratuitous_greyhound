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
    class = """
    flex justify-center
    rounded-md
    border-2 border-yellow-200
    shadow-sm
    w-full px-6 py-3
    text-lg font-medium text-yellow-200 hover:text-yellow-900 hover:font-bold
    hover:bg-yellow-100/50 focus:outline-none
    focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500
    """
    Phoenix.HTML.Tag.content_tag :button, content, attrs ++ [class: class]
  end

  def render_label(form, field, display \\ nil) do
    class = """
    text-yellow-200
    """
    if display do
      label form, field, display, class: class
    else
      label form, field, class: class
    end
  end

end
