defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  def sprite(opts \\ []) do
    sprite = Keyword.fetch!(opts, :sprite)
    rect = if Keyword.get(opts, :center_on_origin?, true) do
      sprite.rect_centered
    else
      sprite.rect_tight
    end
    assigns = [
      socket: Keyword.fetch!(opts, :socket),
      rect: rect,
      image: sprite.image,
      clip_path: sprite.clip_path
    ]
    render("_sprite.html", assigns)
  end

  def center(x, y) do
    size = 14
    assigns = [x: x, y: y, size: size, left: x - size/2, top: y - size/2]
    render("_center.html", assigns)
  end

  def button(opts \\ []) do
    assigns =
      opts
      #|> Keyword.put_new(:text, "")
    render("_button.html", assigns)
  end

  #defp render_template(template, assigns, block) do
  #  assigns =
  #    assigns
  #    |> Map.new()
  #    |> Map.put(:inner_content, block)
  #  render template, assigns
  #end

end
