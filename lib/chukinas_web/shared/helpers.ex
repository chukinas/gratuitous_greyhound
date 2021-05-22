defmodule ChukinasWeb.Components do
  use Phoenix.HTML
  import ChukinasWeb.ErrorHelpers
  alias ChukinasWeb.CssClasses, as: Class

  defmacro __using__(_opts) do
    quote do
      alias ChukinasWeb.Components, as: Component
      alias ChukinasWeb.CssClasses, as: Class
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
    if not valid?(form, field), do: __error_icon__()
  end

  defp __error_icon__ do
    ~E"""
    <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
      <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
      </svg>
    </div>
    """
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

  def text_input(form, field) do
    class = form |> valid(field) |> Class.text_input
    Phoenix.HTML.Form.text_input(form, field, class: class)
  end

  def submit(text, form) do
    class = Class.submit()
    Phoenix.HTML.Form.submit(text, class: class, disabled: !valid?(form))
  end
end

# TODO the tab underline in menu aren't highlighting
