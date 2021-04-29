alias Chukinas.Geometry.{GridSquare, Position, CollidableShape, Path, Rect}

defmodule GridSquare do
  @moduledoc"""
  Represents a single square in a grid
  """

  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :unit_id, integer(), enforce: false
    field :column, integer()
    field :row, integer()
    field :center, Position.t()
    field :size, number()
    field :path, Path.t(), enforce: false
    field :path_type, atom(), enforce: false
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

  def calc_path(square, start_pose) do
    path = Path.get_connecting_path(start_pose, square.center)
    path_type = cond do
      Path.exceeds_angle(path, 30) -> :sharp_turn
      Path.deceeds_angle(path, 10) -> :straight
      true -> :turn
    end
    %{square | path: path, path_type: path_type}
  end

  def to_rect(square) do
    half_size = square.size / 2
    Rect.new(
      square.center |> Position.subtract(half_size),
      square.center |> Position.add(half_size)
    )
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(grid_square) do
      grid_square
      |> GridSquare.to_rect
      |> Rect.list_vertices
    end
  end
end
