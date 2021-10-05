defmodule DreadnoughtWeb.LayoutView.OceanTile do
  use DreadnoughtWeb, :view
  use DreadnoughtWeb.Components
  use Spatial.PositionOrientationSize
  use Spatial.LinearAlgebra
  alias Spatial.Geometry.Rect

  @paper_size 400
  @rotate_classes ~w/
    -rotate-0
    -rotate-1
    -rotate-2
    -rotate-3
    -rotate-6
     rotate-0
     rotate-1
     rotate-2
     rotate-3
     rotate-6
  /

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t
    field :viewbox, String.t
    field :style, String.t
    field :path, String.t
    field :rotate_class, String.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_col_and_row(col, row) do
    position =
      vector_new(col, row)
      |> vector_multiply(@paper_size)
      |> vector_rand_within(30)
      |> vector_to_position
    size = size_from_square(@paper_size)
    rect = Rect.from_position_and_size(position, size)
    %__MODULE__{
      id: "#{col}_#{row}",
      viewbox: viewbox(),
      style: DreadnoughtWeb.Shared.top_left_width_height_from_rect(rect),
      path: path(position),
      rotate_class: rand_rotate_class()
    }
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp rand_rotate_class, do: Enum.random @rotate_classes

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

  def vertices(_coord) do
    radius = 10
    min_size = radius
    max_size = @paper_size - radius
    [
      {min_size, min_size},
      {max_size, min_size},
      {max_size, max_size},
      {min_size, max_size}
    ]
    |> Enum.map(&vector_rand_within(&1, radius))
    |> Enum.map(&vector_round/1)
  end

end

defmodule DreadnoughtWeb.LayoutView.OceanTile.Enum do

  use Spatial.PositionOrientationSize
  alias DreadnoughtWeb.LayoutView.OceanTile

  # *** *******************************
  # *** CONSTRUCTORS

  def from_col_and_row_counts(col_count, row_count) do
    for col <- 0..(col_count - 1), row <- 0..(row_count - 1) do
      OceanTile.from_col_and_row(col, row)
    end
    |> Enum.shuffle
  end

end
