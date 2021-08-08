defmodule ChukinasWeb.ComponentView do

  use ChukinasWeb, :base_view
  use Chukinas.PositionOrientationSize
  alias Chukinas.Geometry.Rect

  defmacro __using__(_opts) do
    quote do
      import ChukinasWeb.ComponentView, except: [render: 1, render: 2, template_not_found: 2]
    end
  end

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

  def render_label(form, field, display \\ nil) do
    class = """
    text-lg text-yellow-200
    """
    if display do
      label form, field, display, class: class
    else
      label form, field, class: class
    end
  end

  def render_p(text, attrs) do
    class = """
    text-yellow-200
    #{attrs}
    """
    Phoenix.HTML.Tag.content_tag :p, text, class: class
  end

  # *** *******************************
  # *** BUTTONS

  # TODO rename `render_button`
  def render_content_button(content, attrs \\ []) do
    Phoenix.HTML.Tag.content_tag :button, content, attrs ++ [class: __button_classes__()]
  end

  def render_submit(form, value, attrs \\ []) do
    opts =
      attrs
      |> Keyword.put_new(:class, __button_classes__())
      |> Keyword.put_new(:disabled, !valid?(form))
    Phoenix.HTML.Form.submit(value, opts)
  end

  defp __button_classes__ do
    """
    flex justify-center
    rounded-md
    border-2 border-yellow-200
    shadow-sm
    w-full px-6 py-3
    text-lg
    text-yellow-200 hover:text-yellow-900 disabled:text-yellow-200
    font-medium hover:font-bold disabled:font-medium
    hover:bg-yellow-100/50 disabled:bg-transparent focus:outline-none
    focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500
    disabled:opacity-50 disabled:cursor-not-allowed
    """
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  #defp add_classes_to_attrs(attrs, class) do
  #  attrs = Enum.into input_attrs, []
  #  #input_classes =
  #end

  defp valid?(form), do: form.source.valid?

end
