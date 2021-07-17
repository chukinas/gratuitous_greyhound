defmodule ChukinasWeb.SpriteView do

  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Geometry.Rect

  def static_sprite(opts \\ []) do
    # TODO I don't like this use of 'opts'. The two 'opts' are anything but. They're required.
    sprite = Keyword.fetch!(opts, :sprite)
    rect = Rect.from_rect(sprite)
    assigns = [
      socket: Keyword.fetch!(opts, :socket),
      rect: rect,
      image_file_path: sprite.image_file_path,
      image_size: sprite.image_size,
      image_clip_path: sprite.image_clip_path,
      transform: sprite.image_origin |> position_add(sprite) |> position_multiply(-1),
      sprite_viewbox: ChukinasWeb.Shared.viewbox(sprite),
      image_viewbox: ChukinasWeb.Shared.viewbox(sprite.image_size)
    ]
    render("static_sprite.html", assigns)
  end

end
