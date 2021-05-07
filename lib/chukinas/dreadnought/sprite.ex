alias Chukinas.Dreadnought.{Sprite}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.{Interpret}
alias Chukinas.Svg
alias Chukinas.Util.Maps

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
    field :relative_origin, Position.t()
    field :mounts, %{margin_id() => Position.t()}
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
      image_clip_path: image_clip_path,
      image_origin: origin,
      rect: rect,
      relative_origin: origin |> Position.subtract(rect),
      mounts: build_mounts(sprite.mounts, rect)
    }
  end

  # *** *******************************
  # *** GETTERS

  def mount(%__MODULE__{mounts: mounts}, mount_id), do: mounts[mount_id]
  def base_filename(%__MODULE__{image_file_path: path}), do: Path.basename(path)

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    %{sprite |
      image_size: Size.multiply(sprite.image_size, scale),
      origin: Position.multiply(sprite.origin, scale),
      image_clip_path: Svg.scale(sprite.image_clip_path, scale),
      rect: Rect.scale(sprite.rect, scale),
      relative_origin: Position.multiply(sprite.relative_origin, scale),
      mounts: scale_mounts(sprite.mounts, scale)
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
    Maps.apply_to_each_val(mounts_map, &Position.multiply(&1, scale))
  end
end
