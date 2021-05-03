alias Chukinas.Dreadnought.{Mission, Unit, MissionBuilder, Island, Player}
alias Chukinas.Geometry.{Pose, Size, Position, Grid}

defmodule MissionBuilder do

  def build do
    # Config
    square_size = 50
    arena = %{
      width: 3000,
      height: 2000
    }
    arena = %{
      width: 1000,
      height: 750
    }
    margin = Size.new(arena.height, arena.width)
    #margin = Size.new(200, 100)
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
    units = [
      Unit.new(1, pose: Pose.new(0, 0, 0), name: "Prince Eugene"),
      #Unit.new(2, pose: Pose.new(800, 155, 75), name: "Billy"),
      Unit.new(3, pose: Pose.new(Position.from_size(grid), 225), player_id: 2, name: "Hoodie")
    ]
    players = [
      Player.new(1, :human),
      Player.new(2, :ai)
    ]
    Mission.new(grid, margin)
    |> Map.put(:islands, islands)
    |> Mission.put(units)
    |> Mission.put(players)
    |> Mission.start
  end
end
