alias Chukinas.Dreadnought.{Mission, Unit, MissionBuilder, Island, Player}
alias Chukinas.Geometry.{Grid}

# TODO rename Mission.Build
defmodule MissionBuilder do

  use Chukinas.PositionOrientationSize

  def dev do
    {grid, margin} = medium_map()
    units = [
      Unit.Builder.red_cruiser(1, pose_new(0, 0, 0), name: "Prince Eugene"),
      Unit.Builder.blue_merchant(2, pose_new(position_from_size(grid), 225), player_id: 2)
    ]
    players = [
      Player.new(1, :human),
      Player.new(2, :ai)
    ]
    Mission.new(grid, margin)
    |> Map.put(:islands, islands())
    |> Mission.put(units)
    |> Mission.put(players)
    |> Mission.start
  end

  defp islands do
    [
      position_new(500, 500),
      position_new(2500, 1200),
      position_new(1500, 1800),
    ]
    |> Enum.with_index
    |> Enum.map(fn {position, index} ->
      position = position_shake position
      Island.random(index, position)
    end)
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
    margin = size_new(arena.height, arena.width)
    #margin = size_new(200, 100)
    [square_count_x, square_count_y] =
      [arena.width, arena.height]
      |> Enum.map(&round(&1 / square_size))
    grid = Grid.new(square_size, position_new(square_count_x, square_count_y))
    units = [
      Unit.Builder.red_destroyer(1, pose_new(0, 0, 0), name: "Prince Eugene"),
      #Unit.Builder.red_cruiser(2, pose_new(800, 155, 75), name: "Billy"),
      Unit.Builder.blue_merchant(3, pose_new(position_from_size(grid), 225), player_id: 2)
    ]
    players = [
      Player.new(1, :human),
      Player.new(2, :ai)
    ]
    Mission.new(grid, margin)
    |> Map.put(:islands, islands())
    |> Mission.put(units)
    |> Mission.put(players)
    |> Mission.start
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
    margin = size_new(arena.height, arena.width)
    [square_count_x, square_count_y] =
      [arena.width, arena.height]
      |> Enum.map(&round(&1 / square_size))
    grid = Grid.new(square_size, position_new(square_count_x, square_count_y))
    {grid, margin}
  end
end
