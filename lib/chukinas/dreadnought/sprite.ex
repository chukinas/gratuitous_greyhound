alias Chukinas.Dreadnought.{Sprite}
alias Chukinas.Geometry.{Position, Size, Rect}
alias Chukinas.Svg.Interpret

defmodule Sprite do

  # *** *******************************
  # *** TYPES

  @type margin_id() :: integer()

  use TypedStruct
  typedstruct enforce: true do
    field :name, String.t()
    # tight - uses smallest bounting rect that contains the clip path
    # centered - uses smallest bounting rect that contains the clip path and is also centered on the origin point
    field :sizing, :tight | :centered
    field :image_path, String.t()
    field :image_size, Size.t()
    # Located relative to spritesheet top-left corner
    field :origin, Position.t()
    field :clip_path, String.t()
    field :rect, Rect.t()
    field :__rect_tight, Rect.t()
    # Located relative to rect's top-left corner
    # TODO can I name this/these better?
    field :relative_origin, Position.t()
    # TODO rename relative_mounts
    field :mounts, %{margin_id() => Position.t()}
  end

  # *** *******************************
  # *** NEW

  def from_parsed_spritesheet(sprite, image_map) do
    %{path: clip_path, rect: rect} = sprite.clip_path |> Interpret.interpret
    origin = Position.rounded(sprite.origin)
    %__MODULE__{
      name: sprite.clip_name,
      sizing: :tight,
      image_path: "/images/spritesheets/" <> image_map.path.name,
      image_size: Size.new(image_map),
      origin: origin,
      clip_path: clip_path,
      rect: rect,
      __rect_tight: rect,
      relative_origin: origin |> Position.subtract(rect),
      mounts: build_mounts(sprite.mounts, rect)
    }
  end

  # *** *******************************
  # *** API

  def scale(%{rect: old_rect} = sprite, scale) do
    new_rect = Rect.scale(sprite.rect, scale)
    %{sprite |
      image_size: Size.multiply(sprite.image_size, scale),
      origin: Position.multiply(sprite.origin, scale),
      clip_path: Svg.scale(sprite.clip_path, scale),
      rect: new_rect,
      __rect: Rect.scale(sprite.__rect, scale),
      relative_origin: Position.multiply(sprite.relative_origin, scale),
      mounts: modify_mounts(sprite.mounts, old_rect, new_rect)
    }
    sprite
    #|> Map.update!(:clip_path, & Svg.scale(&1, scale))
    #|> Map.update!(:rect, & Rect.scale(&1, scale))
  end

  def fit(%{sizing: :tight} = sprite), do: sprite
  # TODO implement:
  def fit(%{sizing: :centered, __rect_tight: new_rect, rect: old_rect} = sprite) do
    %{sprite |
      sizing: :tight,
      rect: new_rect,
      relative_origin: sprite.origin |> Position.subtract(new_rect),
      mounts: modify_mounts(sprite.mounts, old_rect, new_rect)
    }
  end

  def center(%{sizing: :centered} = sprite), do: sprite
  def center(%{sizing: :tight, origin: origin, __rect_tight: old_rect} = sprite) do
    new_rect = Rect.get_centered_rect(origin, old_rect)
    %{sprite |
      sizing: :centered,
      rect: new_rect,
      relative_origin: origin |> Position.subtract(new_rect),
      mounts: modify_mounts(sprite.mounts, old_rect, new_rect)
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

  defp modify_mounts(mounts_map, before_coord_sys, after_coord_sys) do
    Enum.reduce(mounts_map, %{}, fn {id, position}, map ->
      position =
        position
        |> Position.subtract(before_coord_sys)
        |> Position.add(after_coord_sys)
      map |> Map.put(id, position)
    end)
  end
end
