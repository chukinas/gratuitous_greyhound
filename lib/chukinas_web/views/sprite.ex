defmodule ChukinasWeb.SpriteView do

  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Dreadnought.Sprite

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
    angle = case pose.angle do
      0 -> nil
      x when is_number(x) -> x
    end
    assigns = %{
      sprite: sprite,
      conn: conn,
      position: sprite |> position_add(pose) |> position,
      class: Keyword.get(opts, :class, ""),
      attributes: opts |> Keyword.get(:attributes, []) |> attributes_to_maps,
      angle: angle
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

  defp attributes_to_maps(attrs) when is_list(attrs) do
    Enum.map(attrs, fn {name, value} -> %{name: Atom.to_string(name), value: value} end)
  end

end
