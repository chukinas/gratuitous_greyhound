alias Chukinas.Dreadnought.{Sprite, Mount}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.{Interpret}
alias Chukinas.Svg
alias Chukinas.Util.{IdList, Maps}

defmodule Sprite do

  # *** *******************************
  # *** TYPES

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
    %{path: image_clip_path, rect: image_rect} = sprite.image_clip_path |> Interpret.interpret
    origin = Position.rounded(sprite.origin)
    rect = Position.subtract(image_rect, origin)
    %__MODULE__{
      name: sprite.clip_name,
      image_file_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: Size.new(image_map),
      image_origin: origin,
      image_clip_path: image_clip_path,
      rect: rect,
      mounts: build_mounts(sprite.mounts, origin)
    }
  end

  # *** *******************************
  # *** GETTERS

  def mount_position(%__MODULE__{mounts: mounts}, mount_id) do
    mounts
    |> IdList.fetch!(mount_id)
    |> Mount.position
  end
  def base_filename(%__MODULE__{image_file_path: path}), do: Path.basename(path)
  def mounts(%__MODULE__{mounts: mounts}), do: mounts

  # *** *******************************
  # *** API

  def scale(sprite, scale) do
    sprite
    |> Map.update!(:image_size, &Size.multiply(&1, scale))
    |> Map.update!(:image_clip_path, &Svg.scale(&1, scale))
    |> Map.update!(:image_origin, &Position.multiply(&1, scale))
    |> Map.update!(:rect, &Rect.scale(&1, scale))
    |> Maps.map_each(:mounts, &Mount.scale(&1, scale))
  end

  # *** *******************************
  # *** PRIVATE

  defp build_mounts(parsed_mounts, origin) do
    Enum.reduce(parsed_mounts, [], fn %{id: id, x: x, y: y}, mounts ->
      position = Position.new(x, y) |> Position.subtract(origin)
      [Mount.new(id, position) | mounts]
    end)
  end
end
