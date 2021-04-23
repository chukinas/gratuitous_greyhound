alias Chukinas.Dreadnought.Sprite

defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  def sprite(opts \\ []) do
    center? = Keyword.get(opts, :center_on_origin?, true)
    sprite = Keyword.fetch!(opts, :sprite)
    sprite = if center? do
      Sprite.center(sprite)
    else
      Sprite.fit(sprite)
    end
    rect = sprite.rect
    assigns = [
      socket: Keyword.fetch!(opts, :socket),
      rect: rect,
      image_path: sprite.image_path,
      image_size: sprite.image_size,
      clip_path: sprite.clip_path
    ]
    render("_sprite.html", assigns)
  end

  def center(x, y, opts \\ []) do
    scale = Keyword.get(opts, :scale, 1)
    color = case Keyword.get(opts, :type, :origin) do
      :origin -> "pink"
      :mount -> "blue"
    end
    size = 20
    assigns = [size: size, left: x * scale - size / 2, top: y * scale - size / 2, color: color]
    render("_center.html", assigns)
  end

  def button(opts \\ []) do
    assigns =
      opts
      #|> Keyword.put_new(:text, "")
    render("_button.html", assigns)
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
    render("_toggle.html", assigns)
  end

  #defp render_template(template, assigns, block) do
  #  assigns =
  #    assigns
  #    |> Map.new()
  #    |> Map.put(:inner_content, block)
  #  render template, assigns
  #end

end
