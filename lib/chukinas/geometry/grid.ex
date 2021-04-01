alias Chukinas.Geometry.{Grid, GridSquare}

defmodule Grid do
  @moduledoc"""
  Represents the square chess-like board the game is played on
  """

  use TypedStruct

  typedstruct enforce: true do
    field :square_size, integer()
    field :x_count, integer()
    field :y_count, integer()
    field :width, integer()
    field :height, integer()
  end

  # *** *******************************
  # *** NEW

  def new(square_size, x_count, y_count) do
    %__MODULE__{
      square_size: square_size,
      x_count: x_count,
      y_count: y_count,
      width: square_size * x_count,
      height: square_size * y_count
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

  def squares(grid) do
    # TODO use Stream?
    1..grid.y_count
    |> Enum.map(&row_of_squares(grid, &1))
    |> Enum.concat
  end

  def row_of_squares(grid, row_num) do
    # TODO rename row_count and col_count
    1..grid.x_count
    |> Enum.map(fn col -> GridSquare.new(grid.square_size, col, row_num) end)
  end

end
