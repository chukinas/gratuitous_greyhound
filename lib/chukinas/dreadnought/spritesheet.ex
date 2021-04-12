alias Chukinas.Dreadnought.{Spritesheet, Sprite}

defmodule Spritesheet do

  @external_resource "assets/static/images/spritesheets/sprites.svg"

  {:ok, svg_content} = File.read(@external_resource)
  svg_map = XmlToMap.naive_map(svg_content)
  for spritesheet <- Spritesheet.Parser.parse_svg(svg_map) do
    function_name = spritesheet.image.path.root |> String.to_atom
    for sprite <- spritesheet.sprites do
      sprite_struct = Sprite.from_parsed_spritesheet(sprite, spritesheet.image)
      sprite_name = sprite.clip_name
      def unquote(function_name)(unquote(sprite_name)) do
        unquote(Macro.escape(sprite_struct))
      end
    end
  end

end
