defmodule Dreadnought.Sprite.Improved do

    use Dreadnought.LinearAlgebra
    use Dreadnought.PositionOrientationSize
    use Dreadnought.Sprite.Spec
    use Dreadnought.TypedStruct
  alias Dreadnought.Sprite.Builder
  alias Dreadnought.Svg

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :points, [vector]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_sprite_spec(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite =
      sprite_spec
      |> Builder.build
    points_offset =
      sprite.image_origin
      |> position_multiply(-1)
      |> vector_from_position
    points =
      sprite.image_clip_path
      |> Svg.PathDString.to_coords
      |> Enum.map(&vector_add(&1, points_offset))
    %__MODULE__{
      points: points
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def polygon_points_string(%__MODULE__{points: points}) do
    Svg.polygon_points_string_from_coords(points)
  end

end
