alias Chukinas.Geometry.{Grid, GridSquare, Rect}

# TODO rename CommandGrid?
defmodule Grid do
  @moduledoc"""
  Represents the square chess-like board the game is played on
  """

  use Chukinas.PositionOrientationSize
  alias Chukinas.Collide

  typedstruct enforce: true do
    field :square_size, integer()
    # Row/Cols are 1-indexed
    field :start, POS.position_type
    field :count, POS.position_type
    # Calculated Values:
    # TODO I don't like the fact that I'm using width and height to mean something other than px w and h. It screws with my "ubiquitous language"
    size_fields()
  end

  # *** *******************************
  # *** NEW

  def new(%{square_size: size, x_count: x, y_count: y}) do
    square_count = %{x: x, y: y}
    new size, square_count
  end

  def new(square_size, count, start \\ position_new(1, 1))
  when has_position(count)
  and has_position(start) do
    size =
      count
      |> position_multiply(square_size)
      |> size_from_position
    fields =
      %{
        square_size: square_size,
        count: position_new(count),
        start: position_new(start),
      }
      |> merge_size(size)
    struct!(__MODULE__, fields)
  end

  def new(square_size, x_count, y_count, {x_start, y_start}) do
  #def new(square_size, x_count, y_count, {x_start, y_start} \\ {1, 1}) do
    new(
      square_size,
      position_new(x_count, y_count),
      position_new(x_start, y_start)
    )
  end

  # *** *******************************
  # *** API

  # TODO superfluous. remove.
  def size(grid) do
    grid
    |> Map.take(~w/width height/a)
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

  # TODO rename ? bounding_rect
  def to_rect(grid) do
    grid.start
    |> position_new
    |> position_subtract(1)
    |> position_multiply(grid.square_size)
    |> Rect.from_position_and_size(size_new(grid))
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
    filter = Collide.generate_include_filter(collidable)
    wrapped_filter = fn grid_or_square ->
      grid_or_square
      |> filter.()
    end
    include(grid, wrapped_filter, threshold)
  end
  defp include(grid, filter, threshold) when (grid.count.x * grid.count.y) <= threshold do
    grid
    |> all_squares
    |> Stream.filter(filter)
  end
  defp include(grid, filter, threshold) do
    grid
    |> split_grid
    |> Stream.filter(filter)
    |> Stream.map(&include(&1, filter, threshold))
    |> Stream.concat
  end


  defp exclude(squares, nil), do: squares
  defp exclude(squares, obstacles) when is_list(obstacles) do
    squares
    |> Stream.filter(&Collide.avoids_collision_with?(&1, obstacles))
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

  defimpl Collide.IsShape do
    def to_coords(grid) do
      grid
      |> Grid.to_rect
      |> Rect.to_coords
    end
  end
end
