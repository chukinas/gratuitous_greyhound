# TODO ensure this in only called from within Sprite modules
defmodule Dreadnought.Sprite.Importer do

  alias Dreadnought.Sprite
  alias Dreadnought.Sprite.SvgParser

  @external_resource "assets/static/images/spritesheets/sprites.svg"
  Module.register_attribute(__MODULE__, :function_heads, accumulate: true)

  {:ok, svg_content} = File.read(@external_resource)
  svg_map = XmlToMap.naive_map(svg_content)
  for spritesheet <- SvgParser.parse_svg(svg_map) do
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

  def sprite_specs do
    Enum.filter(@function_heads, fn {fun, _} -> fun != :test end)
  end

end
