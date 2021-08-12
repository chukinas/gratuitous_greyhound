# TODO rename DreadnoughtWeb.ComponentsView
defmodule DreadnoughtWeb.Components do
  use Phoenix.HTML
  use DreadnoughtWeb, :view
  import DreadnoughtWeb.ErrorHelpers
  alias DreadnoughtWeb.CssClasses, as: Class

  defmacro __using__(_opts) do
    quote do
      alias DreadnoughtWeb.Components, as: Component
      alias DreadnoughtWeb.CssClasses, as: Class
    end
  end

  def error_paragraph(form, field) do
    class = Class.error_paragraph()
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:p, translate_error(error),
        class: "invalid-feedback " <> class,
        phx_feedback_for: input_id(form, field)
      )
    end)
  end

  def error_icon_text_input(form, field) do
    if not valid?(form, field), do: render("error_icon.html")
  end

  def valid?(form), do: form.source.valid?
  def valid?(form, field) do
    form.errors |> Keyword.get_values(field) |> Enum.empty?
  end

  def valid(valid?) when is_boolean(valid?) do
    if valid?, do: :valid, else: :invalid
  end
  def valid(form), do: form |> valid? |> valid
  def valid(form, field), do: form |> valid?(field) |> valid

  def text_input(form, field, opts \\ []) do
    class = form |> valid(field) |> Class.text_input
    opts = merge_class_and_opts(opts, class)
    Phoenix.HTML.Form.text_input(form, field, opts)
  end

  def url_join(form, url) do
    render("url_join.html", maybe_url: url, form: form, submit_class: Class.join_btn())
  end

  defp merge_class_and_opts(opts, class) do
    {_, new_class} = Keyword.get_and_update(opts, :class, fn current_class ->
      new_class = case current_class do
        nil -> class
        old_class -> Class.join(old_class, class)
      end
      {current_class, new_class}
    end)
    new_class
  end

  # *** *******************************
  # *** BUTTONS

  def submit(text, form, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:class, Class.submit())
      |> Keyword.put_new(:disabled, !valid?(form))
    Phoenix.HTML.Form.submit(text, opts)
  end

  def button(text, opts \\ []) do
    attrs = Keyword.merge(opts,
      type: "button",
      value: text,
      class: Class.submit()
    )
    Phoenix.HTML.Tag.tag(:input, attrs)
  end

end
