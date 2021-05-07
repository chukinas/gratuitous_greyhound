alias Chukinas.Dreadnought.{Sprite}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.{Interpret}
alias Chukinas.Svg

defmodule Sprite do

  # *** *******************************
  # *** TYPES

  @type margin_id() :: integer()

  use TypedStruct
  typedstruct enforce: true do
    field :name, String.t()
    # tight - uses smallest bounting rect that contains the clip path
    # centered - uses smallest bounting rect that contains the clip path and is also centered on the origin point
    field :image_file_path, String.t()
    field :image_size, Size.t()
    # Located relative to spritesheet/image top-left corner
    field :image_origin, Position.t()
    # TODO remove
    field :origin, Position.t()
    field :image_clip_path, String.t()
    field :rect, Rect.t()
    field :__rect_tight, Rect.t()
    # Located relative to rect's top-left corner
    field :relative_origin, Position.t()
    field :relative_mounts, %{margin_id() => Position.t()}
    # TODO remove:
    field :sizing, :tight | :centered
  end

  # *** *******************************
  # *** NEW

  def from_parsed_spritesheet(sprite, image_map) do
    %{path: image_clip_path, rect: rect} = sprite.image_clip_path |> Interpret.interpret
    origin = Position.rounded(sprite.origin)
    %__MODULE__{
      name: sprite.clip_name,
      sizing: :tight,
      image_file_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: Size.new(image_map),
      image_origin: origin,
      image_clip_path: image_clip_path,
      origin: origin,
      rect: rect,
      __rect_tight: rect,
      relative_origin: origin |> Position.subtract(rect),
      relative_mounts: build_mounts(sprite.mounts, rect)
    }
  end

  # *** *******************************
  # *** GETTERS

  def mount(%__MODULE__{relative_mounts: mounts}, mount_id), do: mounts[mount_id]
  def base_filename(%__MODULE__{image_file_path: path}), do: Path.basename(path)

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    %{sprite |
      image_size: Size.multiply(sprite.image_size, scale),
      origin: Position.multiply(sprite.origin, scale),
      image_clip_path: Svg.scale(sprite.image_clip_path, scale),
      rect: Rect.scale(sprite.rect, scale),
      __rect_tight: Rect.scale(sprite.__rect_tight, scale),
      relative_origin: Position.multiply(sprite.relative_origin, scale),
      relative_mounts: scale_mounts(sprite.mounts, scale)
    }
  end

  # *** *******************************
  # *** PRIVATE

  defp build_mounts(parsed_mounts, rect) do
    Enum.reduce(parsed_mounts, %{}, fn %{id: id, x: x, y: y}, mounts_map ->
      position = Position.new(x, y) |> Position.subtract(rect)
      mounts_map |> Map.put(id, position)
    end)
  end

  defp scale_mounts(mounts_map, scale) do
    map_values(mounts_map, &Position.multiply(&1, scale))
  end

  defp map_values(%{} = map, fun) do
    Enum.reduce(map, %{}, fn {key, value}, new_map ->
      Map.put(new_map, key, fun.(value))
    end)
  end
end
