alias Chukinas.Dreadnought.{ManeuverPlanning, Unit, UnitAction, ById, ManeuverPartial}
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

  # TODO move these to a new module Maneuver
  # TODO Maneuver.t() :: [ManeuverPartial.t()]
  def move_to(unit, pos) do
    path = Path.get_connecting_path(unit.pose, pos)
    Unit.put_path(unit, path)
  end

  def repeat_last_maneuver_twice(%Unit{
    compound_path: [path_partial],
    pose: pose1
  } = unit) do
    %ManeuverPartial{geo_path: last_round_path} = path_partial
    geo_path1 =
      last_round_path
      |> Path.put_pose(pose1)
    pose2 = Path.get_end_pose(geo_path1)
    geo_path2 =
      last_round_path
      |> Path.put_pose(pose2)
    manuever = [
      ManeuverPartial.new(geo_path1),
      ManeuverPartial.new(geo_path2, fractional_start_time: 1)
    ]
    unit |> Unit.put_compound_path(manuever)
  end

  # *** *******************************
  # *** MANEUVER EXECUTION

  def get_unit_with_tentative_maneuver(units, maneuver_action) do
    unit = units |> ById.get!(maneuver_action.unit_id)
    case UnitAction.value(maneuver_action) do
      %Position{} = pos -> move_to(unit, pos)
      :exit_or_run_aground ->
        unit
        |> IOP.inspect
        |> repeat_last_maneuver_twice
    end
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
