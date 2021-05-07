alias Chukinas.Dreadnought.{Sprite, Mount}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.{Interpret}
alias Chukinas.Svg
alias Chukinas.Util.{ById, Maps}

defmodule Sprite do

  # *** *******************************
  # *** TYPES

  @type margin_id() :: integer()

  use TypedStruct
  typedstruct enforce: true do
    field :name, String.t()
    field :image_file_path, String.t()
    field :image_size, Size.t()
    field :image_origin, Position.t()
    field :image_clip_path, String.t()
    field :rect, Rect.t()
    field :mounts, [Mount.t()]
  end

  # *** *******************************
  # *** NEW

  def from_parsed_spritesheet(sprite, image_map) do
    %{path: image_clip_path, rect: rect} = sprite.image_clip_path |> Interpret.interpret
    origin = Position.rounded(sprite.origin)
    %__MODULE__{
      name: sprite.clip_name,
      image_file_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: Size.new(image_map),
      image_clip_path: image_clip_path,
      image_origin: origin,
      rect: rect,
      mounts: build_mounts(sprite.mounts, rect)
    }
  end

  # *** *******************************
  # *** GETTERS

  def mount_position(%__MODULE__{mounts: mounts}, mount_id) do
    mounts
    |> ById.get!(mount_id)
    |> Mount.position
  end
  def base_filename(%__MODULE__{image_file_path: path}), do: Path.basename(path)

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    %{sprite |
      image_size: Size.multiply(sprite.image_size, scale),
      origin: Position.multiply(sprite.origin, scale),
      image_clip_path: Svg.scale(sprite.image_clip_path, scale),
      rect: Rect.scale(sprite.rect, scale),
    }
    |> Maps.map_each(:mounts, &Position.multiply(&1, scale))
  end

  # *** *******************************
  # *** PRIVATE

  defp build_mounts(parsed_mounts, rect) do
    Enum.reduce(parsed_mounts, [], fn %{id: id, x: x, y: y}, mounts ->
      position = Position.new(x, y) |> Position.subtract(rect)
      [Mount.new(id, position) | mounts]
    end)
  end
end
