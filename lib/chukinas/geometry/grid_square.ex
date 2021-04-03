alias Chukinas.Geometry.{GridSquare, Position, CollidableShape}

defmodule GridSquare do
  @moduledoc"""
  Represents a single square in a grid
  """

  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :column, integer()
    field :row, integer()
    field :center, Position.t()
    field :size, number()
  end

  # *** *******************************
  # *** NEW

  def new(size, col, row) do
    %__MODULE__{
      id: "#{col}-#{row}",
      column: col,
      row: row,
      center: Position.new((col - 0.5) * size, (row - 0.5) * size),
      size: size
    }
  end

  # *** *******************************
  # *** API

  # TODO superfluous. remove.
  def size(grid) do
    %{
      width: grid.square_size * grid.x_count,
      height: grid.square_size * grid.y_count
    }
  end

  # TODO this should be a protocol implementation
  def to_vertices(square) do
    half_edge = square.size / 2
    center = square.center
    [
      Position.add(center, -half_edge, -half_edge),
      Position.add(center, +half_edge, -half_edge),
      Position.add(center, +half_edge, +half_edge),
      Position.add(center, -half_edge, +half_edge),
    ]
    |> Enum.map(&Position.to_vertex/1)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(grid_square), do: GridSquare.to_vertices(grid_square)
  end
end
