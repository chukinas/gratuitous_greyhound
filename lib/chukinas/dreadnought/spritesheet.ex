alias Chukinas.Dreadnought.Spritesheet

defmodule Spritesheet do

  @external_resource "assets/static/spritesheets/clip_paths.svg"

  {:ok, svg_content} = File.read(@external_resource)
  svg_map = XmlToMap.naive_map(svg_content)
  for spritesheet <- Spritesheet.Parser.parse_svg(svg_map) do

    def unquote(spritesheet.image.path.root |> String.to_atom)(), do: :ok
  end

end
