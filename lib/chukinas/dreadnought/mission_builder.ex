alias Chukinas.Dreadnought.{Mission, Unit, MissionBuilder, Island}
alias Chukinas.Geometry.{Pose, Size, Position, Grid}

defmodule MissionBuilder do

  def build do
    # Config
    square_size = 50
    arena = %{
      #width: 500,
      #height: 500
      width: 1500,
      height: 1000
    }
    margin = Size.new(arena.height, arena.width)
    unit = Unit.new(1, pose: Pose.new(100, 155, 75))
    # TODO 185 This does not belong here
    motion_range_polygon = Unit.get_motion_range unit
    islands = [
      Position.new(500, 500),
      Position.new(2500, 1200),
      Position.new(1500, 1800),
    ]
    |> Enum.with_index
    |> Enum.map(fn {position, index} ->
      position = Position.shake position
      Island.random(index, position)
    end)
    [square_count_x, square_count_y] =
      [arena.width, arena.height]
      |> Enum.map(&round(&1 / square_size))
    grid = Grid.new(square_size, square_count_x, square_count_y)
    Mission.new()
    |> Mission.put_dimensions(grid, margin)
    |> Map.put(:islands, islands)
    |> Mission.put(unit)
    |> Mission.calc_command_squares(motion_range_polygon)
  end
end
