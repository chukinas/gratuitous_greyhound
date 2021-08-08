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

  def render_text_input(form, field) do
    class = """
    block
    w-full mt-1 px-6 py-3
    rounded-md
    shadow-sm
    text-3xl text-yellow-300
    appearance-none
    bg-transparent
    border-2 border-yellow-300
    focus:outline-none focus:ring-2 focus:ring-yellow-300
    """
    Phoenix.HTML.Form.text_input(form, field, class: class)
  end

  def render_error(form, field) do
    class = """
    text-red-300 font-bold
    """
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:p, translate_error(error),
        class: "invalid-feedback " <> class,
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  # *** *******************************
  # *** DOTS
  #     These are currently only used in the Gallery.
  #     They show the mounts and mounting point

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

  # *** *******************************
  # *** TEXT

  def render_header(value, class) do
    attrs = []
    class = """
    text-4xl sm:text-6xl uppercase font-extrabold tracking-widest text-yellow-400
    #{class}
    """
    Phoenix.HTML.Tag.content_tag :h1, value, attrs ++ [class: class]
  end

  def render_label(form, field, display \\ nil) do
    class = """
    text-xl text-yellow-300
    """
    if display do
      label form, field, display, class: class
    else
      label form, field, class: class
    end
  end

  def render_p(text, attrs \\ "") do
    class = """
    text-yellow-300
    #{attrs}
    """
    Phoenix.HTML.Tag.content_tag :p, text, class: class
  end

  # *** *******************************
  # *** BUTTONS

  def render_button(value, attrs \\ []) do
    Phoenix.HTML.Tag.content_tag :button, value, attrs ++ [class: __button_classes__()]
  end

  def render_submit(form, value) do
    class = """
    disabled:animate-none
    """
    opts =
      [
        class: [class, " ", __button_classes__()],
        disabled: !valid?(form)
      ]
    Phoenix.HTML.Form.submit(value, opts)
  end

  defp __button_classes__ do
    """
    rounded-md
    border-2 border-yellow-300
    shadow-sm
    w-full px-6 py-3
    text-3xl
    text-yellow-300
    font-medium hover:font-bold disabled:font-medium
    hover:bg-yellow-100/10 disabled:bg-transparent focus:outline-none
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
