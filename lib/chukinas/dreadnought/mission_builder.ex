alias Chukinas.Dreadnought.{Mission, Unit, MissionBuilder, Island}
alias Chukinas.Geometry.{Pose, Size, Position}

defmodule MissionBuilder do

  def build do
    # Config
    square_size = 50
    arena = %{
      width: 3000,
      height: 2000
    }
    #arena = %{
    #  width: 500,
    #  height: 500
    #}
    margin = Size.new(arena.height, arena.width)
    #margin = Size.new(200, 200)
    unit = Unit.new(1, pose: Pose.new(100, 155, 75))
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
    Mission.new()
    |> Mission.set_grid(square_size, round(arena.width / square_size), round(arena.height / square_size), margin)
    |> Map.put(:islands, islands)
    |> Mission.set_unit(unit)
    |> Mission.calc_command_squares(motion_range_polygon)
  end
end
