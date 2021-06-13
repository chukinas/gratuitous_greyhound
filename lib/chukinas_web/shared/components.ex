defmodule ChukinasWeb.Components do
  use Phoenix.HTML
  use ChukinasWeb, :view
  import ChukinasWeb.ErrorHelpers
  alias ChukinasWeb.CssClasses, as: Class

  defmacro __using__(_opts) do
    quote do
      alias ChukinasWeb.Components, as: Component
      alias ChukinasWeb.CssClasses, as: Class
    end
  end

  def toggle(id, opts \\ []) do
    assigns =
      [
        label: nil,
        phx_click: nil,
        phx_target: nil,
        is_enabled?: false
      ]
      |> Keyword.merge(opts)
      |> Keyword.put(:id, id)
    render("toggle.html", assigns)
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
    #assigns = Opts.merge!(opts,
    #  text: "placeholder text",
    #  phx_click: nil,
    #  phx_target: nil
    #)
    Phoenix.HTML.Tag.tag(
      :input,
      type: "button",
      value: text,
      class: Class.submit(),
      phx_click: opts[:phx_click]
    )
  end

end
