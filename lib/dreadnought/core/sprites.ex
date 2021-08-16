defmodule Dreadnought.Core.Sprites do

  alias Dreadnought.Core.Sprite
  alias Dreadnought.Core.SpritesheetParser

  @external_resource "assets/static/images/spritesheets/sprites.svg"
  Module.register_attribute(__MODULE__, :function_heads, accumulate: true)

  # *** *******************************
  # *** TYPES

  @type t :: Sprite.t

  # *** *******************************
  # *** API

  # TODO move to Sprite and delete this file?
  {:ok, svg_content} = File.read(@external_resource)
  svg_map = XmlToMap.naive_map(svg_content)
  for spritesheet <- SpritesheetParser.parse_svg(svg_map) do
    function_name = spritesheet.image.path.root |> String.to_atom
    for sprite <- spritesheet.sprites do
      sprite_struct = Sprite.from_parsed_spritesheet(sprite, spritesheet.image)
      sprite_name = sprite.clip_name
      @function_heads {function_name, sprite_name}
      def unquote(function_name)(unquote(sprite_name)) do
        unquote(Macro.escape(sprite_struct))
      end
    end
  end

  def all_grouped_by_function do
    all()
    |> Enum.group_by(&Sprite.base_filename/1)
  end

  def all do
    Enum.reduce(all_function_heads(), [], fn {function_name, sprite_name}, sprites ->
      new_sprite = apply __MODULE__, function_name, [sprite_name]
      [new_sprite | sprites]
    end)
  end

  defp all_function_heads do
    Stream.filter(@function_heads, fn {fun, _} -> fun != :test end)
  end

  # *** *******************************
  # *** SPRITE API

  def scale(sprite, scale), do: Sprite.scale(sprite, scale)

  def mounts(sprite), do: Sprite.mounts(sprite)

  def mount_position(sprite, mount_id), do: Sprite.mount_position(sprite, mount_id)

end
