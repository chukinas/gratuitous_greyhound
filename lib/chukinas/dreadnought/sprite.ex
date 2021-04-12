alias Chukinas.Dreadnought.{Sprite, Mount}
alias Chukinas.Geometry.{Position, Size}

defmodule Sprite do

  use TypedStruct

  typedstruct enforce: true do
    field :origin, Position.t()
    field :start, Position.t()
    field :size, Size.t()
    field :half_size, Size.t()
    field :mounts, [Mount.t()]
    field :image, Sprite.Image.t()
    field :clip_path, String.t()
  end

  #def from_parsed_spritesheet() do
  #end

  def from_unitbuilder(map) do
    rect = map.rect
    map =
      map
      |> Map.put(:start, Position.new(rect.x, rect.y))
      |> Map.put(:size, Size.new(rect.width, rect.height))
      |> Map.put(:half_size, Size.new(rect.half_width, rect.half_height))
      |> Map.put(:mounts, map.mounts |> Enum.map(& struct(Mount, &1)))
      |> Map.put(:image, struct(Sprite.Image, map.image))
    struct(__MODULE__, map)
  end
end

defmodule Mount do
  use TypedStruct
  typedstruct do
    field :id, integer()
    field :position, Position.t()
  end
end

defmodule Sprite.Image do
  use TypedStruct
  typedstruct do
    field :path, String.t()
    field :size, Size.t()
  end
end
