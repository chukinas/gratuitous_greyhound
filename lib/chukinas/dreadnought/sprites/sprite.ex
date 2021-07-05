defmodule Chukinas.Dreadnought.Sprite do

  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Sprites.Mount
  alias Chukinas.Geometry.Rect
  alias Chukinas.Svg
  alias Chukinas.Svg.Interpret
  alias Chukinas.Util.IdList
  alias Chukinas.Util.Maps

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :name, String.t()
    field :image_file_path, String.t()
    # TODO change to size type
    field :image_size, any
    # TODO change to position type
    field :image_origin, any
    field :image_clip_path, String.t()
    rect_fields()
    field :mounts, [Mount.t()]
  end

  # *** *******************************
  # *** NEW

  def from_parsed_spritesheet(sprite, image_map) do
    %{path: image_clip_path, rect: image_rect} = sprite.image_clip_path |> Interpret.interpret
    origin = position_new_rounded(sprite.origin)
    rect =
      image_rect
      |> Rect.from_rect
      |> position_subtract(origin)
    fields = %{
      name: sprite.clip_name,
      image_file_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: size_new(image_map),
      image_origin: origin,
      image_clip_path: image_clip_path,
      mounts: build_mounts(sprite.mounts, origin)
    }
    |> Rect.merge_rect(rect)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def mount_position(%__MODULE__{mounts: mounts}, mount_id) do
    mounts
    |> IdList.fetch!(mount_id)
    |> position_new
  end
  def base_filename(%__MODULE__{image_file_path: path}), do: Path.basename(path)
  def mounts(%__MODULE__{mounts: mounts}), do: mounts

  def rect(%__MODULE__{} = sprite) do
    Rect.from_rect(sprite)
  end

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    sprite
    |> Map.update!(:image_size, &size_multiply(&1, scale))
    |> Map.update!(:image_clip_path, &Svg.scale(&1, scale))
    |> Map.update!(:image_origin, &position_multiply(&1, scale))
    |> Rect.scale(scale)
    |> Maps.map_each(:mounts, &Mount.scale(&1, scale))
  end

  # *** *******************************
  # *** PRIVATE

  defp build_mounts(parsed_mounts, origin) do
    Enum.reduce(parsed_mounts, [], fn %{id: id, x: x, y: y}, mounts ->
      position = position_new(x, y) |> position_subtract(origin)
      [Mount.new(id, position) | mounts]
    end)
  end
end
