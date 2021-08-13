defmodule Dreadnought.Core.MissionBuilder do

  use Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Island
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.UnitBuilder
  alias Dreadnought.Geometry.Grid

  # *** *******************************
  # *** REDUCERS

  def add_player(%Mission{} = mission, player_uuid, player_name) do
    player_id = 1 + Mission.player_count(mission)
    player = Player.new_human(player_id, player_uuid, player_name)
    Mission.put(mission, player)
  end

  def maybe_start(%Mission{} = mission) do
    if Mission.ready?(mission) do
      mission
      |> put_fleets
      |> Mission.start
    else
      mission
    end
  end

  # *** *******************************
  # *** PRIVATE CONVERTERS

  @spec put_fleets(Mission.t) :: Mission.t
  defp put_fleets(%Mission{} = mission) do
    player_ids_and_fleet_colors = Enum.zip([
      Mission.player_ids(mission),
      [:red, :blue],
      # TODO second pose needs to be relative to bl corner of play area
      [pose_new(100, 100, 45), pose_new(500, 500, -135)]
    ])
    Enum.reduce(player_ids_and_fleet_colors, mission, fn {player_id, color, pose}, mission ->
      next_unit_id = Mission.unit_count(mission) + 1
      units = build_fleet(color, next_unit_id, player_id, pose)
      Mission.put(mission, units)
    end)
  end

  # *** *******************************
  # *** HELPERS

  def islands do
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

  def small_map, do: grid_and_margin(800, 500)
  def medium_map, do: grid_and_margin(1400, 700)
  def large_map, do: grid_and_margin(3000, 2000)

  # *** *******************************
  # *** PRIVATE HELPERS

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

  def build_fleet(:red, starting_id, player_id, pose) do
    formation =
      [
        {  0,   0},
        {-50,  50},
        {-50, -50},
      ]
    poses = for unit_coord <-formation, do: formation_to_pose(pose, unit_coord)
    [
      UnitBuilder.build(:red_cruiser, starting_id, player_id, Enum.at(poses, 0), name: "Navarin"),
      UnitBuilder.build(:red_destroyer, starting_id + 1, player_id, Enum.at(poses, 1), name: "Potemkin"),
      UnitBuilder.build(:red_destroyer, starting_id + 2, player_id, Enum.at(poses, 2), name: "Sissoi")
    ]
  end

  def build_fleet(:blue, starting_id, player_id, pose) do
    formation =
      [
        {  0,   0},
        {-50,  50},
      ]
    poses = for unit_coord <-formation, do: formation_to_pose(pose, unit_coord)
    [
      UnitBuilder.build(:blue_dreadnought, starting_id, player_id, Enum.at(poses, 0), name: "Washington"),
      UnitBuilder.build(:blue_destroyer, starting_id + 1, player_id, Enum.at(poses, 1), name: "Detroit")
    ]
  end

  def human_and_ai_players do
    [
      Player.new_human(1, "PLACEHOLDER", "Billy Jane"),
      Player.new_ai(2, "PLACEHOLDER", "R2-D2")
    ]
  end

  def formation_to_pose(lead_pose, unit_coord_wrt_pose) when has_pose(lead_pose) and is_vector(unit_coord_wrt_pose) do
    lead_pose
    |> csys_from_pose
    |> csys_translate(unit_coord_wrt_pose)
    |> csys_to_pose
  end

end
