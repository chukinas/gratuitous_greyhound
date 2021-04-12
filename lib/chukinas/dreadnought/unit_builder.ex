alias Chukinas.Dreadnought.Unit.Builder
alias Chukinas.Dreadnought.Sprite
alias Chukinas.Geometry.{Position, Size}

defmodule Builder do

  file_path = "assets/static/images/test.svg"
  {:ok, svg_content} = File.read file_path
  svg_map = XmlToMap.naive_map(svg_content)
  for key <- Map.keys(svg_map["svg"]["#content"]["g"]["#content"]["path"]) do
    def print_this(unquote(key)), do: IOP.inspect(unquote(key))
  end

  def form("red_ship_2") do
    mymap = %{
      origin: Position.new(68, 44),
      mounts: [
        %{
          id: 1,
          position: Position.new(70, 44)
        },
        %{
          id: 2,
          # TODO Position maybe ought to be called Vector
          position: Position.new(22, 44)
        }
      ],
      image: %{
        path: "/images/spritesheets/red.png",
        size: Size.new(122, 57)
      },
      clip_path: "M 73,56 49,56 22,57 2,52 0,38 19,28 l 52,2 20,6 9,7 0,5 z",
      # These are used merely for getting more useful calculated values?
      # TODO, also, many of these are just good guesses.
      # When I auto-generate this with macros, they'll be exact.
      min_x: 0,
      max_x: 100,
      min_y: 20,
      max_y: 57
    }
    add_centered_bounding_rect(mymap)
    |> Sprite.from_unitbuilder
  end

  defp add_centered_bounding_rect(item) when is_map(item) do
    # Returns a box whose center shares the item's center
    half_x_size = max(
      abs(item.origin.x - item.min_x),
      abs(item.origin.x - item.max_x)
    )
    |> ceil
    half_y_size = max(
      abs(item.origin.y - item.min_y),
      abs(item.origin.y - item.max_y)
    )
    |> ceil
    rect = %{
      x: round(item.origin.x - half_x_size),
      y: round(item.origin.y - half_y_size),
      half_width: half_x_size,
      half_height: half_y_size,
      width: half_x_size |> double,
      height: half_y_size |> double,
    }
    Map.put item, :rect, rect
  end

  defp double(val), do: 2 * val
end
