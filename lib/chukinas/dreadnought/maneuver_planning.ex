alias Chukinas.Dreadnought.{ManeuverPlanning, Unit}
alias Chukinas.Geometry.{GridSquare, Grid, Collide, Path, Straight, Turn, Position, Polygon}

defmodule ManeuverPlanning do
  @moduledoc """
  Logic for calculating the maneuver options available to a unit
  """

  # *** *******************************
  # *** API

  def get_cmd_squares(unit, grid, islands, foresight \\ 1)
  def get_cmd_squares(%{pose: pose} = unit, grid, islands, 1) do
    maneuver_polygon = get_maneuver_polygon(unit)
    grid
    |> Grid.squares(include: maneuver_polygon, exclude: islands)
    |> Stream.map(&GridSquare.calc_path(&1, pose))
    |> Stream.filter(&Collide.avoids?(&1.path, islands))
    |> Stream.map(&%GridSquare{&1 | unit_id: unit.id})
  end
  def get_cmd_squares(unit, grid, islands, target_depth) do
    alias ManeuverPlanning.Token
    get_squares = fn unit -> get_cmd_squares(unit, grid, islands) |> Enum.shuffle end
    original_squares = get_squares.(unit)
    initial_tokens = Stream.map(original_squares, fn square ->
      Token.new(unit, square, get_squares, target_depth, &move_to/2)
    end)
    initial_tokens
    |> Stream.flat_map(&Token.expand/1)
    |> Stream.map(&Token.square/1)
  end

  def move_to(unit, pos) do
    path = Path.get_connecting_path(unit.pose, pos)
    Unit.put_path(unit, path)
  end

  # *** *******************************
  # *** PRIVATE

  defp get_maneuver_polygon(%Unit{pose: pose}, trim_angle \\ 0) do
    max_distance = 400
    min_distance = 200
    angle = 45
    [
      Straight.new(pose, min_distance),
      Turn.new(pose, min_distance, trim_angle - angle),
      Turn.new(pose, max_distance, trim_angle - angle),
      Straight.new(pose, max_distance),
      Turn.new(pose, max_distance, trim_angle + angle),
      Turn.new(pose, min_distance, trim_angle + angle),
    ]
    |> Stream.map(&Path.get_end_pose/1)
    |> Enum.map(&Position.to_tuple/1)
    |> Polygon.new
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  #defimpl Inspect do
  #  import Inspect.Algebra
  #  def inspect(path, opts) do
  #    unit_map = path |> Map.take([:id, :pose, :maneuver_svg_string, :player_id])
  #    concat ["#PotPath<", to_doc(unit_map, opts), ">"]
  #  end
  #end
end
