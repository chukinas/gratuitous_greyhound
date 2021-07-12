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

defmodule ChukinasWeb.Shared do

  alias ChukinasWeb.DreadnoughtPlayView

  def top_left_width_height_from_rect(rect) do
    DreadnoughtPlayView.render_rect_as_style_attrs(rect)
  end

  def left_top_from_position(position) do
    DreadnoughtPlayView.left_top_from_position position
  end

  def width_height_from_size(size) do
    DreadnoughtPlayView.width_height_from_size size
  end

end
