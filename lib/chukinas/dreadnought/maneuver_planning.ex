alias Chukinas.Dreadnought.{ManeuverPlanning, Unit, Maneuver}
alias Chukinas.Geometry.{GridSquare, Grid}
alias Chukinas.{Collide, Paths}
alias Paths.Turn

defmodule ManeuverPlanning do
  @moduledoc """
  Logic for calculating the maneuver options available to a unit
  """

  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** API

  def get_cmd_squares(unit, grid, islands, foresight \\ 1)
  def get_cmd_squares(unit, grid, islands, 1) do
    maneuver_polygon = get_maneuver_polygon(unit)
    grid
    |> Grid.squares(include: maneuver_polygon, exclude: islands)
    |> Stream.map(&GridSquare.calc_path(&1, pose_from_map(unit)))
    |> Stream.filter(&Collide.avoids_collision_with?(&1.path, islands))
    |> Stream.map(&%GridSquare{&1 | unit_id: unit.id})
  end

  def get_cmd_squares(unit, grid, islands, target_depth) do
    alias ManeuverPlanning.Token
    get_squares = fn unit -> get_cmd_squares(unit, grid, islands) |> Enum.shuffle end
    original_squares = get_squares.(unit)
    initial_tokens = Stream.map(original_squares, fn square ->
      Token.new(unit, square, get_squares, target_depth, &Maneuver.move_to/2)
    end)
    initial_tokens
    |> Stream.flat_map(&Token.expand/1)
    |> Stream.map(&Token.square/1)
  end

  # *** *******************************
  # *** PRIVATE

  defp get_maneuver_polygon(%Unit{} = unit, trim_angle \\ 0) do
    pose = unit |> pose_from_map
    max_distance = 400
    min_distance = 200
    angle = 45
    [
      Paths.straight_new(pose, min_distance),
      Turn.new(pose, min_distance, trim_angle - angle),
      Turn.new(pose, max_distance, trim_angle - angle),
      Paths.straight_new(pose, max_distance),
      Turn.new(pose, max_distance, trim_angle + angle),
      Turn.new(pose, min_distance, trim_angle + angle),
    ]
    |> Stream.map(&Paths.get_end_pose/1)
    |> Enum.map(&position_to_tuple/1)
    |> Collide.shape_from_coords
  end
end
