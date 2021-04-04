alias Chukinas.Geometry.{Grid, GridSquare, Collide, Position}

# TODO rename CommandGrid?
defmodule Grid do
  @moduledoc"""
  Represents the square chess-like board the game is played on
  """

  use TypedStruct

  typedstruct enforce: true do
    field :square_size, integer()
    # Row/Cols are 1-indexed
    field :start, Position.t()
    field :count, Position.t()
    # Calculated Values:
    field :width, integer()
    field :height, integer()
  end

  # *** *******************************
  # *** NEW

  def new(square_size, %Position{} = count, %Position{} = start) do
    new(square_size, count.x, count.y, {start.x, start.y})
  end
  def new(square_size, x_count, y_count, {x_start, y_start} \\ {1, 1}) do
    %__MODULE__{
      square_size: square_size,
      start: Position.new(x_start, y_start),
      count: Position.new(x_count, y_count),
      width: square_size * x_count,
      height: square_size * y_count
    }
  end

  # *** *******************************
  # *** API

  # TODO superfluous. remove.
  def size(grid) do
    %{
      width: grid.square_size * grid.count.x,
      height: grid.square_size * grid.count.y
    }
  end

  def squares(grid, opts \\ []) do
    opts =
      [include: nil, exclude: nil]
      |> Keyword.merge(opts)
      |> Map.new
    1..grid.count.y
    |> Stream.map(&row_of_squares(grid, &1))
    |> Stream.concat
    |> exclude(opts.exclude)
  end

  def row_of_squares(grid, row_num) do
    # TODO rename row_count and col_count
    1..grid.count.x
    |> Enum.map(fn col -> GridSquare.new(grid.square_size, col, row_num) end)
  end

  # *** *******************************
  # *** PRIVATE

  def exclude(squares, nil), do: squares
  def exclude(squares, obstacles) when is_list(obstacles) do
    squares
    |> Stream.filter(&Collide.avoids?(&1, obstacles))
  end

  def split_grid(grid) do
    split_axis = if grid.count.x > grid.count.y, do: :x, else: :y
    {first_split_count, second_split_count} = split_integer(grid.count[split_axis])
    first_count =
      grid.count
      |> Map.put(split_axis, first_split_count)
    second_count =
      grid.count
      |> Map.put(split_axis, second_split_count)
    second_start =
      grid.start
      |> Map.update!(split_axis, &(&1 + first_split_count))
    first_half = new(grid.square_size, first_count, grid.start)
    second_half = new(grid.square_size, second_count, second_start)
    {first_half, second_half}
  end

  def split_integer(number) do
    half = round(number / 2)
    {half, number - half}
  end
end
