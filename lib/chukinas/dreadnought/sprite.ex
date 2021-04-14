alias Chukinas.Dreadnought.{Sprite, Mount}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.Interpret

defmodule Sprite do

  use TypedStruct

  # TODO add name
  typedstruct enforce: true do
    # Note: `rel` means relative to origin (the sprite's 'center')
    field :origin, Position.t()
    # TODO Rename abs_start
    field :start, Position.t()
    field :start_rel, Position.t()
    field :size, Size.t()
    field :mountings, [Mount.t()]
    field :image, Sprite.Image.t()
    field :clip_path, String.t()
    field :rect_tight, Rect.t()
    field :rect_centered, Rect.t()
  end

  def from_parsed_spritesheet(sprite, image_map) do
    svg = sprite.clip_path |> Interpret.interpret
    size = Size.from_positions(svg.min, svg.max)
    image = Sprite.Image.new(
      "/images/spritesheets/" <> image_map.path.name,
      image_map.width,
      image_map.height
    )
    origin = Position.rounded(sprite.origin)
    build_mounting = fn %{id: id, x: x, y: y} ->
      rel_position =
        Position.rounded(x, y)
        |> Position.subtract(origin)
      Mount.new(id, rel_position)
    end
    %__MODULE__{
      # TODO this isn't a Position.t()
      origin: origin,
      start: svg.min,
      start_rel: Position.subtract(svg.min, origin),
      size: size,
      mountings: sprite.mountings |> Enum.map(build_mounting),
      image: image,
      clip_path: svg.path,
      rect_tight: svg.rect,
      rect_centered: get_centered_rect(origin, svg.rect),
    }
  end

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

# TODO rename Mounting
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

defmodule Sprite.Image do
  use TypedStruct
  typedstruct do
    field :path, String.t()
    field :size, Size.t()
  end
  def new(path, width, height) do
    %__MODULE__{
      path: path,
      size: Size.rounded(width, height)
    }
  end
end
