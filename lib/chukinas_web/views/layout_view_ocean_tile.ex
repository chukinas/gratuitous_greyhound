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
    field :viewbox, String.t
    field :style, String.t
    field :path, String.t
  end

  def paper_size, do: @paper_size

  # *** *******************************
  # *** CONSTRUCTORS

  def from_position(position) when has_position(position) do
    size = size_from_square(@paper_size)
    rect = Rect.from_position_and_size(position, size)
    %__MODULE__{
      viewbox: viewbox(),
      style: ChukinasWeb.Shared.top_left_width_height_from_rect(rect),
      path: path(position)
    }
  end

  def from_col_and_row(col, row) do
    position_new(col, row)
    |> position_multiply(@paper_size)
    |> from_position
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp viewbox, do: [0, 0, @paper_size, @paper_size] |> Enum.join(" ")

  def path(position) do
    vertices = position |> vector_from_position |> vertices
    vertex_as_list = fn index ->
      vertices
      |> Enum.at(index)
      |> Tuple.to_list
    end
    [
      "M",
      vertex_as_list.(0),
      "L",
      vertex_as_list.(1),
      "L",
      vertex_as_list.(2),
      "L",
      vertex_as_list.(3),
      "Z"
    ]
    |> List.flatten
    |> Enum.join(" ")
  end

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

  def from_col_and_row_counts(col_count, row_count) do
    for col <- 0..(col_count - 1), row <- 0..(row_count - 1) do
      position_new(col, row) |> position_multiply(OceanTile.paper_size())
    end
    |> Enum.shuffle
    |> Enum.map(&OceanTile.from_position/1)
  end

end
