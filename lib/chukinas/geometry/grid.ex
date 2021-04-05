alias Chukinas.Geometry.{Grid, GridSquare, Collide, Position, CollidableShape, Rect}

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
    default_opts = [include: nil, exclude: nil, threshold: 9]
    keys = Keyword.keys default_opts
    opts =
      default_opts
      |> Keyword.merge(opts)
      |> Map.new
    if (opts |> Map.drop(keys) |> Enum.count) > 0 do
      throw "Grid.squares received invalid options!"
    end
    grid
    |> include(opts.include, opts.threshold)
    |> exclude(opts.exclude)
  end

  def to_rect(grid) do
    start_position =
      grid.start
      |> Position.add(-1)
      |> Position.multiply(grid.square_size)
    end_position = Position.add(start_position, grid.width, grid.height)
    Rect.new(start_position, end_position)
  end

  # *** *******************************
  # *** PRIVATE

  defp all_squares(grid) do
    grid.start.y
    |> Stream.iterate(&(&1 + 1))
    |> Stream.take(grid.count.y)
    |> Stream.map(&row_of_squares(grid, &1))
    |> Stream.concat
  end

  defp row_of_squares(grid, row_num) do
    grid.start.x
    |> Stream.iterate(&(&1 + 1))
    |> Stream.take(grid.count.x)
    |> Stream.map(fn col -> GridSquare.new(grid.square_size, col, row_num) end)
  end

  defp include(grid, nil, _threshold), do: all_squares(grid)
  defp include(grid, collidable, threshold) when not is_function(collidable) do
    IOP.inspect collidable, "The target"
    filter = Collide.generate_include_filter(collidable)
    wrapped_filter = fn grid_or_square ->
      grid_or_square
      |> IOP.inspect("grid or square")
      |> filter.()
      |> IOP.inspect("above grid/sq collides w/ target")
    end
    include(grid, wrapped_filter, threshold)
  end
  defp include(grid, filter, threshold) when (grid.count.x * grid.count.y) <= threshold do
    IOP.inspect "small count"
    grid
    |> all_squares
    |> Stream.filter(filter)
  end
  defp include(grid, filter, threshold) do
    IOP.inspect "large count"
    grid
    |> split_grid
    |> Stream.filter(filter)
    |> Stream.map(&include(&1, filter, threshold))
    |> Stream.concat
  end


  defp exclude(squares, nil), do: squares
  defp exclude(squares, obstacles) when is_list(obstacles) do
    squares
    |> Stream.filter(&Collide.avoids?(&1, obstacles))
  end

  defp split_grid(grid) do
    count = Map.from_struct(grid.count)
    split_axis = if count.x > count.y, do: :x, else: :y
    {first_split_count, second_split_count} = split_integer(count[split_axis])
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
    [first_half, second_half]
  end

  defp split_integer(number) do
    half = round(number / 2)
    {half, number - half}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollidableShape do
    def to_vertices(grid) do
      grid
      |> Grid.to_rect
      |> Rect.list_vertices
    end
  end
end
