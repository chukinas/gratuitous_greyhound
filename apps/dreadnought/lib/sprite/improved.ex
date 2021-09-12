defmodule Dreadnought.Sprite.Improved do

    use Spatial.LinearAlgebra
    use Spatial.PositionOrientationSize
    use Dreadnought.Sprite.Spec
    use Spatial.TypedStruct
  alias Dreadnought.Core.Mount
  alias Dreadnought.Sprite
  alias Dreadnought.Sprite.Builder
  alias Dreadnought.Svg

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    # TODO rename coords?
    field :points, [vector]
    # TODO postiion type
    field :image_position, any
    field :image_size, any
    field :image_path, any
    field :mounts, [Mount.t()]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_sprite_spec(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite_spec |> Builder.build |> from_sprite
  end

  def from_sprite(%Sprite{} = sprite) do
    image_position = Sprite.image_position(sprite)
    points =
      sprite.image_clip_path
      |> Svg.PathDString.to_coords
      |> Enum.map(&vector_add(&1, vector_from_position(image_position)))
    %__MODULE__{
      points: points,
      image_position: image_position,
      image_size: sprite.image_size,
      image_path: sprite.image_file_path,
      mounts: sprite.mounts
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def coords(%__MODULE__{points: value}), do: value

  def image_path(%__MODULE__{image_path: value}), do: value

  def polygon_points_string(%__MODULE__{points: points}) do
    Svg.polygon_points_string_from_coords(points)
  end

  def image_size(%__MODULE__{image_size: value}), do: value

  def mounts(%__MODULE__{mounts: value}), do: value

end

# *** *********************************
# *** IMPLEMENTATIONS
# *** *********************************

alias Dreadnought.Sprite.Improved, as: Sprite

defimpl Spatial.BoundingRect, for: Sprite do
    use Spatial.LinearAlgebra
  alias Spatial.Geometry.Rect
  def of(sprite) do
    sprite
    |> Sprite.coords
    |> Enum.map(&vector_to_position/1)
    |> Rect.bounding_rect_from_positions
  end
end

defimpl Spatial.BoundingRect, for: Tuple do
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite.Improved, as: Sprite
  def of(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite_spec |> Sprite.from_sprite_spec |> Spatial.BoundingRect.of
  end
end
