alias Chukinas.Dreadnought.{Mission, Unit, MissionBuilder, Island, Player}
alias Chukinas.Geometry.{Pose, Size, Position, Grid}

# TODO rename Mission.Build
defmodule MissionBuilder do

  def dev do
    {grid, margin} = medium_map()
    units = [
      Unit.Builder.red_cruiser(1, pose: Pose.new(0, 0, 0), name: "Prince Eugene"),
      Unit.Builder.blue_merchant(2, pose: Pose.new(Position.from_size(grid), 225), player_id: 2)
    ]
    players = [
      Player.new(1, :human),
      Player.new(2, :ai)
    ]
    Mission.new(grid, margin)
    |> Map.put(:islands, [])
    |> Mission.put(units)
    |> Mission.put(players)
    |> Mission.start
    |> IOP.inspect("Mission.Build first turn")
  end

  def build do
    # Config
    square_size = 50
    arena = %{
      width: 3000,
      height: 2000
    #  width: 700,
    #  height: 400
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
      Unit.Builder.red_destroyer(1, pose: Pose.new(0, 0, 0), name: "Prince Eugene"),
      #Unit.Builder.red_cruiser(2, pose: Pose.new(800, 155, 75), name: "Billy"),
      Unit.Builder.blue_merchant(3, pose: Pose.new(Position.from_size(grid), 225), player_id: 2)
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
    |> IOP.inspect("MissionBuilder new mission")
  end

  def small_map, do: grid_and_margin(800, 500)
  def medium_map, do: grid_and_margin(1400, 700)
  def large_map, do: grid_and_margin(3000, 2000)

  def grid_and_margin(width, height) do
    square_size = 50
    arena = %{
      width: width,
      height: height
    }
    margin = Size.new(arena.height, arena.width)
    [square_count_x, square_count_y] =
      [arena.width, arena.height]
      |> Enum.map(&round(&1 / square_size))
    grid = Grid.new(square_size, square_count_x, square_count_y)
    {grid, margin}
  end
end
