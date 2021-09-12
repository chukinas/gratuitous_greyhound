defmodule DreadnoughtWeb.SpriteView do

    use DreadnoughtWeb, :view
    use DreadnoughtWeb.Components
    use Spatial.PositionOrientationSize
    use Spatial.LinearAlgebra
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite

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

  def absolute_sprite(conn, sprite, opts \\ [])

  def absolute_sprite(conn, sprite_spec, opts) when is_sprite_spec(sprite_spec) do
    sprite = Sprite.Builder.build(sprite_spec)
    absolute_sprite(conn, sprite, opts)
  end

  # TODO temp func clause
  def absolute_sprite(conn, %Sprite{} = sprite, opts) do
    pose = Keyword.get(opts, :pose, pose_origin())
    assigns = %{
      conn: conn,
      sprite: sprite,
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
        |> size_add(2 * @drop_shadow_padding)
        |> size_new,
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
      padded_image_size:
        sprite.image_size
        |> size_add(2 * @drop_shadow_padding)
        |> size_new,
      padded_image_viewbox: DreadnoughtWeb.Shared.viewbox(sprite.image_size, @drop_shadow_padding),
      size:
        sprite
        |> size_add(2 * @drop_shadow_padding)
        |> size_new,
      svg_path: sprite.image_clip_path,
      transform:
        sprite.image_origin
        #|> position_add(@drop_shadow_padding)
        |> position_add(sprite)
        |> position_multiply(-1)
        |> position_new
    ]
    render("drop_shadow.html", assigns)
  end

end
