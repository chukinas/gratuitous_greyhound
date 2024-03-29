defmodule Dreadnought.Sprite do

    use Spatial.LinearAlgebra
    use Spatial.PositionOrientationSize
    use Spatial.TypedStruct
  alias Dreadnought.Core.Mount
  alias Spatial.Geometry.Rect
  alias Dreadnought.Svg
  alias Dreadnought.Svg.PathDString
  alias Util.IdList
  alias Util.Maps

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    rect_fields()
    field :name, String.t()
    field :image_file_path, String.t()
    # TODO change to size type
    field :image_size, any
    # TODO change to position type
    field :image_origin, any
    field :image_clip_path, String.t()
    field :mounts, [Mount.t()]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_parsed_spritesheet(sprite, image_map) do
    %{path: image_clip_path, rect: image_rect} = sprite.image_clip_path |> PathDString.interpret
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
  # *** REDUCERS

  def scale(sprite, scale) do
    sprite
    |> Map.update!(:image_size, &size_multiply(&1, scale))
    |> Map.update!(:image_clip_path, &Svg.scale(&1, scale))
    |> Map.update!(:image_origin, &position_multiply(&1, scale))
    |> Rect.scale(scale)
    |> Maps.map_each(:mounts, &Mount.scale(&1, scale))
  end

  # *** *******************************
  # *** CONVERTERS

  def base_filename(%__MODULE__{image_file_path: path}), do: Path.basename(path)

  def mount_position(%__MODULE__{mounts: mounts}, mount_id) do
    mounts
    |> IdList.fetch!(mount_id)
    |> position_new
  end

  def mounts(%__MODULE__{mounts: mounts}), do: mounts

  def image_position(%__MODULE__{image_origin: origin}) do
    origin
    |> position_multiply(-1)
  end

  # *** *******************************
  # *** PRIVATE

  # TODO remove
  defp build_mounts(parsed_mounts, origin) do
    Enum.reduce(parsed_mounts, [], fn %{id: id, x: x, y: y}, mounts ->
      position = position_new(x, y) |> position_subtract(origin)
      [Mount.new(id, position) | mounts]
    end)
  end
end

# *** *********************************
# *** IMPLEMENTATIONS
# *** *********************************

# TODO should bounding rect be in the Rect namespace?
alias Dreadnought.Sprite, as: Sprite

defimpl Spatial.BoundingRect, for: Sprite do
  def of(sprite) do
    Spatial.BoundingRect.of(sprite |> Sprite.Improved.from_sprite)
  end
end
