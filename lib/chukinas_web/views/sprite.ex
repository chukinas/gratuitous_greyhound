defmodule ChukinasWeb.SpriteView do

  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Dreadnought.Sprite

  @drop_shadow_padding 10

  def static_sprite(conn, %Sprite{} = sprite) do
    assigns = [
      socket: conn,
      sprite: sprite,
      image_file_path: sprite.image_file_path,
      image_size: sprite.image_size,
      image_clip_path: sprite.image_clip_path,
      transform: sprite.image_origin |> position_add(sprite) |> position_multiply(-1),
    ]
    render("static_sprite.html", assigns)
  end

  def absolute_sprite(conn, %Sprite{} = sprite, opts \\ []) do
    pose = Keyword.get(opts, :pose, pose_origin())
    assigns = %{
      conn: conn,
      sprite: sprite,
      # TODO rename attrs
      attrs: opts[:attrs],
      drop_shadow_padding: @drop_shadow_padding,
      position:
        sprite
        |> position_add(pose)
        |> position_subtract(@drop_shadow_padding)
        |> position_new,
      class: Keyword.get(opts, :class, ""),
      angle:
        case pose.angle do
          0 -> nil
          x when is_number(x) -> x
        end,
      size:
        sprite
        |> size_new,
        #|> size_add(2 * @drop_shadow_padding),
      transform_origin:
        sprite
        |> position_multiply(-1)
        |> position_add(@drop_shadow_padding)
        |> position_new
    }
    render("absolute_sprite.html", assigns)
  end

  def drop_shadow(%Sprite{} = sprite) do
    assigns = [
      sprite: sprite,
      image_size: sprite.image_size,
      image_clip_path: sprite.image_clip_path,
      transform: sprite.image_origin |> position_add(sprite) |> position_multiply(-1),
      image_viewbox: ChukinasWeb.Shared.viewbox(sprite.image_size)
    ]
    render("static_sprite.html", assigns)
  end

end
