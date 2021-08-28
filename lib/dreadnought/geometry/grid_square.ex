alias Dreadnought.Geometry.{GridSquare, Rect}
alias Dreadnought.Paths

defmodule GridSquare do
  @moduledoc"""
  Represents a single square in a grid
  """

  use Dreadnought.PositionOrientationSize
  use Dreadnought.TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :unit_id, integer(), enforce: false
    field :column, integer()
    field :row, integer()
    field :center, POS.position_type
    field :size, number()
    field :path, Paths.t(), enforce: false
    field :path_type, atom(), enforce: false
  end

  # *** *******************************
  # *** NEW

  def new(size, col, row) do
    %__MODULE__{
      id: "#{col}-#{row}",
      column: col,
      row: row,
      center: position((col - 0.5) * size, (row - 0.5) * size),
      size: size
    }
  end

  # *** *******************************
  # *** GETTERS

  # TODO rename center_position
  def position(%__MODULE__{center: value}), do: value

  def size(%__MODULE__{size: value}), do: value

  # *** *******************************
  # *** API

  def calc_path(square, start_pose) do
    path = Paths.get_connecting_path(start_pose, square.center)
    path_type = cond do
      Paths.exceeds_angle(path, 30) -> :sharp_turn
      Paths.deceeds_angle(path, 10) -> :straight
      true -> :turn
    end
    %{square | path: path, path_type: path_type}
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Dreadnought.Geometry.GridSquare

defimpl Dreadnought.BoundingRect, for: GridSquare do
  alias Dreadnought.Geometry.Rect
  def of(%GridSquare{center: position, size: size}) do
    Rect.from_centered_square(position, size)
  end
end

defimpl Dreadnought.Collide.IsShape, for: GridSquare do
  def to_coords(grid_square) do
    grid_square
    |> Dreadnought.BoundingRect.of
    |> Rect.to_coords
  end
end
