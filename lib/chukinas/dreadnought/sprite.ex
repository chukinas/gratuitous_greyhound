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
    # Note: `rel` means relative to origin (the sprite's 'center')
    # Origin is a position relative to top-left corner of spritesheet image
    field :origin, Position.t()
    # TODO Rename abs_start
    field :start, Position.t()
    field :start_rel, Position.t()
    field :size, Size.t()
    field :mountings, [Mount.t()]
    field :image_path, String.t()
    field :image_size, Size.t()
    # Svg path string; located rel to spritesheet tl-corner
    field :clip_path, String.t()
    # Smallest bounding rect around the clip path; located rel to spritesheet tl-corner
    field :rect_tight, Rect.t()
    # Smallest rect that has the origin at its center; located rel to spritesheet tl-corner
    field :rect_centered, Rect.t()
  end

  # *** *******************************
  # *** NEW

  def from_parsed_spritesheet(sprite, image_map) do
    svg = sprite.clip_path |> Interpret.interpret
    size = Size.from_positions(svg.min, svg.max)
    origin = Position.rounded(sprite.origin)
    build_mounting = fn %{id: id, x: x, y: y} ->
      rel_position =
        Position.rounded(x, y)
        |> Position.subtract(origin)
      Mount.new(id, rel_position)
    end
    %__MODULE__{
      name: sprite.clip_name,
      origin: origin,
      start: svg.min,
      start_rel: Position.subtract(svg.min, origin),
      size: size,
      mountings: sprite.mountings |> Enum.map(build_mounting),
      image_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: Size.new(image_map),
      clip_path: svg.path,
      rect_tight: svg.rect,
      rect_centered: get_centered_rect(origin, svg.rect),
    }
  end

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    sprite
    |> update_in([:image, :size], & Size.multiply(&1, scale))
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
