alias Chukinas.Geometry.{GridSquare, Position}

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
  end

  # *** *******************************
  # *** NEW

  def new(size, col, row) do
    %__MODULE__{
      id: "#{col}-#{row}",
      column: col,
      row: row,
      center: Position.new(col/size, row/size)
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

end
