defmodule Chukinas.Dreadnought.MissionBuilder do

  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Island
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Geometry.Grid

  # *** *******************************
  # *** ONLINE GAME

  @spec online :: Mission.t
  def online() do
    {grid, margin} = medium_map()
    Mission.new(grid, margin)
    |> Map.put(:islands, islands())
    # Still needs players, units, and needs to be started
  end

  def add_player(%Mission{} = mission, player_uuid, player_name) do
    player_id = 1 + Mission.player_count(mission)
    player = Player.new_human(player_id, player_uuid, player_name)
    Mission.put(mission, player)
  end

  def maybe_start(%Mission{} = mission) do
    if ready?(mission) do
      mission
      |> Mission.start
    else
      mission
    end
  end

  @spec ready?(Mission.t) :: boolean
  defp ready?(%Mission{} = mission) do
    #Enum.all?(
      Mission.player_count(mission) in 1..2
      #each_player_has_at_least_one_unit(mission)
    #)
  end

  #@spec each_player_has_at_least_one_unit(Mission.t) :: boolean
  #defp each_player_has_at_least_one_unit(mission) do
  #  units = Mission.units(mission)
  #  mission
  #  |> Mission.player_ids
  #  |> Enum.all?(&Unit.Enum.active_player_unit_count(units, &1) > 0)
  #end

  # *** *******************************
  # *** DEV

  def dev do
    {grid, margin} = medium_map()
    units = [
      Unit.Builder.red_cruiser(1, pose_new(0, 0, 0), name: "Prince Eugene"),
      Unit.Builder.blue_merchant(2, pose_new(position_from_size(grid), 225), player_id: 2)
    ]
    Mission.new(grid, margin)
    |> Map.put(:islands, islands())
    |> Mission.put(units)
    |> Mission.put(human_and_ai_players())
    |> Mission.start
  end

  # *** *******************************
  # *** PRIVATE

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
    Mission.new(grid, margin)
    |> Map.put(:islands, islands())
    |> Mission.put(units)
    |> Mission.put(human_and_ai_players())
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

  # *** *******************************
  # *** COMMON BUILDS

  def human_and_ai_players do
    [
      Player.new_human(1, "PLACEHOLDER", "Billy Jane"),
      Player.new_ai(2, "PLACEHOLDER", "R2-D2")
    ]
  end

end
