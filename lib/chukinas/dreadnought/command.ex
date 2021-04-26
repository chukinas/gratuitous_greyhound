alias Chukinas.Dreadnought.{Command}
alias Chukinas.Geometry.{Position, Collide, Grid, Polygon, Position, Straight, Turn, GridSquare, Path}

defmodule Command do
  @moduledoc """
  Represents the actions a unit will take at the end of the turn
  """

  # *** *******************************
  # *** TYPES

  @type unit_id() :: integer()

  use TypedStruct
  typedstruct do
    field :unit_id, unit_id(), enforce: true
    field :commands, [:exit_or_run_aground | {:move_to, Position.t()}]
  end

  # *** *******************************
  # *** NEW

  def new(opts \\ []), do: struct!(__MODULE__, opts)

  def move_to(unit_id, position), do: new(unit_id: unit_id, commands: [{:move_to, position}])
  def exit_or_run_aground(unit_id), do: new(unit_id: unit_id, commands: [:exit_or_run_aground])

  # *** *******************************
  # *** MANEUVER PLANNING

  # def get_cmd_squares(unit, grid) do
  #   get_cmd_squares(unit, grid, [])
  # end

  def get_cmd_squares(%{pose: pose} = unit, grid, islands) do
    cmd_zone = get_motion_range(unit)
    grid
    |> Grid.squares(include: cmd_zone, exclude: islands)
    |> Stream.map(&GridSquare.calc_path(&1, pose))
    |> Stream.filter(&Collide.avoids?(&1.path, islands))
  end

  defp get_motion_range(%{pose: pose}, trim_angle \\ 0) do
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
end
