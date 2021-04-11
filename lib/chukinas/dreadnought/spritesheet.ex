alias Chukinas.Dreadnought.Spritesheet

defmodule Spritesheet do

  file_path = "assets/static/images/test.svg"
  {:ok, svg_content} = File.read file_path
  svg_map = XmlToMap.naive_map(svg_content)
  for key <- Map.keys(svg_map["svg"]["#content"]["g"]["#content"]["path"]) do
    def print_this(unquote(key)), do: IOP.inspect(unquote(key))
  end

  def test(), do: :ok
end
