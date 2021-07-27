defmodule ChukinasWeb.LayoutView.OceanTile do
  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Geometry.Rect

  @paper_size 200

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :rect, Rect.t
    field :viewbox, String.t
    field :style, String.t
    field :path, String.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_position(position) when has_position(position) do
    size = size_from_square(@paper_size)
    rect = Rect.from_position_and_size(position, size)
    style = ChukinasWeb.Shared.top_left_width_height_from_rect(rect)
    %__MODULE__{
      rect: rect,
      viewbox: viewbox(),
      style: style,
      path: build_square()
    }
  end

  def from_col_and_row(col, row) do
    position_new(col, row)
    |> position_multiply(@paper_size)
    |> from_position
  end

  # *** *******************************
  # *** ENUM

  def build_square do
    "M 0 0 L 190 5 L 200 180 L 0 200 Z"
  end

  def build_square(position) when has_position(position) do
    [
      {0,                     0},
      {@paper_size,           0},
      {@paper_size, @paper_size},
      {0,           @paper_size}
    ]
    |> Enum.map(&vector_to_position/1)
    |> Enum.map(&position_add(&1, position))
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp viewbox, do: [0, 0, @paper_size, @paper_size] |> Enum.join(" ")

  def vertices(coord) when is_vector(coord) do
    [
      {0,                     0},
      {@paper_size,           0},
      {@paper_size, @paper_size},
      {0,           @paper_size}
    ]
    |> Enum.map(&vector_add(&1, coord))
  end

end

defmodule ChukinasWeb.LayoutView.OceanTile.Enum do

  use Chukinas.PositionOrientationSize
  alias ChukinasWeb.LayoutView.OceanTile

  # *** *******************************
  # *** CONSTRUCTORS

  def from_col_and_row_counts(col_count, row_count, paper_size) do
    for col <- 0..col_count, row <- 0..row_count do
      position_new(col, row) |> position_multiply(paper_size)
    end
    |> Enum.shuffle
    |> Enum.map(&OceanTile.from_position/1)
  end

end
