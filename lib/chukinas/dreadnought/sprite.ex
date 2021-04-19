alias Chukinas.Dreadnought.{Sprite, Mount}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.Interpret

defmodule Sprite do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  # TODO add name
  typedstruct enforce: true do
    field :name, String.t()
    # tight - uses smallest bounting rect that contains the clip path
    # centered - uses smallest bounting rect that contains the clip path and is also centered on the origin point
    field :sizing, :tight | :centered
    field :start_rel, Position.t()
    field :mountings, [Mount.t()]
    field :image_path, String.t()
    field :image_size, Size.t()
    # All these are located relative to spritesheet top-left corner
    field :origin, Position.t()
    field :clip_path, String.t()
    field :rect, Rect.t()
    # TODO remove these
    field :rect_tight, Rect.t()
    field :rect_centered, Rect.t()
  end

  # *** *******************************
  # *** NEW

  def from_parsed_spritesheet(sprite, image_map) do
    svg = sprite.clip_path |> Interpret.interpret
    #size = Size.from_positions(svg.min, svg.max)
    origin = Position.rounded(sprite.origin)
    build_mounting = fn %{id: id, x: x, y: y} ->
      rel_position =
        Position.rounded(x, y)
        |> Position.subtract(origin)
      Mount.new(id, rel_position)
    end
    %__MODULE__{
      name: sprite.clip_name,
      sizing: :tight,
      origin: origin,
      start_rel: Position.subtract(svg.rect, origin),
      mountings: sprite.mountings |> Enum.map(build_mounting),
      image_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: Size.new(image_map),
      clip_path: svg.path,
      rect_tight: svg.rect,
      rect_centered: get_centered_rect(origin, svg.rect),
      rect: svg.rect,
    }
  end

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    sprite
    |> Map.update!(:image_size, & Size.multiply(&1, scale))
    |> Map.update!(:origin, & Position.multiply(&1, scale))
    #|> Map.update!(:clip_path, & Svg.scale(&1, scale))
    #|> Map.update!(:rect, & Rect.scale(&1, scale))
  end

  def center(%{sizing: :centered} = sprite), do: sprite
  def center(%{sizing: :tight} = sprite) do
    sprite
    |> Map.put(:sizing, :centered)
    #|> Map.update!(:origin, & Position.multiply(&1, scale))
    #|> Map.update!(:clip_path, & Svg.scale(&1, scale))
    #|> Map.update!(:rect, & Rect.scale(&1, scale))
  end

  # *** *******************************
  # *** PRIVATE

  defp get_centered_rect(origin, rect) do
    half_width = max(
      abs(origin.x - rect.x),
      abs(rect.x + rect.width - origin.x)
    )
    half_height = max(
      abs(origin.y - rect.y),
      abs(rect.y + rect.height - origin.y)
    )
    dist_from_origin = Position.new(half_width, half_height)
    Rect.new(
      Position.subtract(origin, dist_from_origin),
      Position.add(origin, dist_from_origin)
    )
  end
end

# TODO This is referred to as a mounting in other places. Change those to say 'mount' instead
defmodule Mount do
  use TypedStruct
  typedstruct do
    field :id, integer()
    field :position, Position.t()
  end
  def new(%{id: id, x: x, y: y}), do: new(id, x, y)
  def new(id, x, y) do
    new(id, Position.new(x, y))
  end
  def new(id, position) do
    %__MODULE__{
      id: String.to_integer(id),
      position: position
    }
  end
end
