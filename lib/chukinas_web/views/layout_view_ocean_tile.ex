defmodule ChukinasWeb.LayoutView.OceanTile do
  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Geometry.Rect
  alias Chukinas.Math

  @paper_size 400

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
      style: ChukinasWeb.Shared.top_left_width_height_from_rect(rect),
      path: path(position),
      rotate_class: rand_rotate_class()
    }
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp rand_rotate_class do
    sign = Math.rand_sign()
    angle = Enum.random [0, 3, 6]
    [
      (if sign > 0, do: "", else: "-"),
      "rotate-",
      angle
    ]
    |> Enum.join("")
  end

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

defmodule ChukinasWeb.LayoutView.OceanTile.Enum do

  use Chukinas.PositionOrientationSize
  alias ChukinasWeb.LayoutView.OceanTile

  # *** *******************************
  # *** CONSTRUCTORS

  def from_col_and_row_counts(col_count, row_count) do
    for col <- 0..(col_count - 1), row <- 0..(row_count - 1) do
      OceanTile.from_col_and_row(col, row)
    end
    |> Enum.shuffle
  end

end
