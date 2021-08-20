defmodule DreadnoughtWeb.ComponentView do
  @moduledoc"""
  A catch-all for fragments, chunks
  """

  use DreadnoughtWeb, :base_view
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Geometry.Rect

  defmacro __using__(_opts) do
    quote do
      import DreadnoughtWeb.ComponentView, except: [render: 1, render: 2, template_not_found: 2]
    end
  end

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
  # *** FRAGMENTS

  def render_dropshadow_def, do: render("dropshadow_def.html", [])

  def render_dropshadow_filter, do: ~s/filter="url(#paperdropshadow)"/

  def render_gsap_import, do: render("gsap_import.html", [])

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

  def render_header(value, class \\ "") do
    attrs = []
    class = """
    text-4xl sm:text-6xl uppercase font-extrabold tracking-widest text-yellow-400
    sm:mx-auto sm:w-full mt-6 text-center
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

  def render_large_text(text) do
    render_p(text, "text-4xl")
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
    w-full px-6 py-3
    text-3xl text-yellow-300 font-medium
    #{__hover_bg__()}
    focus:outline-none
    transition-transform duration-75 transform hover:scale-105 disabled:scale-100
    focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500
    disabled:opacity-50 disabled:cursor-not-allowed
    """
  end

  # *** *******************************
  # *** DROPDOWN

  def dropdown_button_class do
    """
    inline-flex items-center justify-center
    p-2
    rounded-md
    text-yellow-300
    bg-gray-800/70
    focus:outline-none focus:ring-2 focus:ring-inset focus:ring-yellow-300
    #{__hover_bg__()}
    """
  end

  def dropdown_class do
    """
    origin-top-right absolute right-0 mt-1 w-72
    bg-gray-800/90
    rounded-md
    text-yellow-300 text-center
    border-2 border-yellow-300
    """
  end

  def dropdown_item_class do
    """
    block px-4 py-2
    text-lg
    #{__hover_bg__()}
    """
  end

  # *** *******************************
  # *** COMMON CLASSES

  defp __hover_bg__, do: "hover:bg-yellow-400/10 /10 disabled:bg-transparent"

  # *** *******************************
  # *** PRIVATE HELPERS

  #defp add_classes_to_attrs(attrs, class) do
  #  attrs = Enum.into input_attrs, []
  #  #input_classes =
  #end

  defp valid?(form), do: form.source.valid?

end
