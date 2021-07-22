defmodule ChukinasWeb.SharedComponents do

  alias ChukinasWeb.SharedView

  # TODO delete
  def card(assigns \\ %{}, do: block), do: render_template("card.html", assigns, block)

  def import_gsap, do: render_template("import_gsap.html")

  defp render_template(template, assigns \\ []) do
    SharedView.render(template, assigns)
  end

  defp render_template(template, assigns, block) do
    assigns =
      assigns
      |> Map.new()
      |> Map.put(:inner_content, block)
    SharedView.render(template, assigns)
  end

end
