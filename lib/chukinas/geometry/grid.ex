alias Chukinas.Geometry.{Grid, GridSquare, Collide}

# TODO rename CommandGrid?
defmodule Grid do
  @moduledoc"""
  Represents the square chess-like board the game is played on
  """

  use TypedStruct

  typedstruct enforce: true do
    field :square_size, integer()
    # Row/Cols are 1-indexed
    field :x_start, integer()
    field :y_start, integer()
    field :x_count, integer()
    field :y_count, integer()
    # Calculated Values:
    field :width, integer()
    field :height, integer()
  end

  # *** *******************************
  # *** NEW

  def new(square_size, x_count, y_count, {x_start, y_start} \\ {1, 1}) do
    %__MODULE__{
      square_size: square_size,
      x_start: x_start,
      y_start: y_start,
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

  def squares(grid, opts \\ []) do
    opts =
      [include: nil, exclude: nil]
      |> Keyword.merge(opts)
      |> Map.new
    1..grid.y_count
    |> Stream.map(&row_of_squares(grid, &1))
    |> Stream.concat
    |> exclude(opts.exclude)
  end

  def row_of_squares(grid, row_num) do
    # TODO rename row_count and col_count
    1..grid.x_count
    |> Enum.map(fn col -> GridSquare.new(grid.square_size, col, row_num) end)
  end

  # *** *******************************
  # *** PRIVATE

  def exclude(squares, nil), do: squares
  def exclude(squares, obstacles) when is_list(obstacles) do
    squares
    |> Stream.filter(&Collide.avoids?(&1, obstacles))
  end

end
