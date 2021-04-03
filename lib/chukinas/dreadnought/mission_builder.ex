alias Chukinas.Dreadnought.{Mission, Unit, Command, CommandQueue, CommandIds, MissionBuilder, Island}
alias Chukinas.Geometry.{Pose, Size, Position}

defmodule MissionBuilder do

  def demo() do
    commands =
      1..5
      |> Enum.map(&Command.random/1)
    deck =
      CommandQueue.new(2, get_default_command_builder(), commands)
      |> CommandQueue.draw(5)
    Mission.new()
    |> Mission.set_arena(1000, 750)
    |> Mission.put(Unit.new(2, start_pose: Pose.new(0, 0, 45)))
    |> Mission.put(deck)
    |> Mission.issue_command(CommandIds.new 2, 1, 5)
  end

  def grid_lab do
    # Config
    square_size = 30
    arena = %{
      width: 3000,
      height: 2500
    }
    margin = Size.new(arena.height, arena.width)
    unit = Unit.new(Enum.random(1..1000), pose: Pose.new(100, 155, 75)) |> Unit.set_position(margin)
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
    |> Mission.set_overlapping_squares(motion_range_polygon)
  end

  def from_live_action(live_action) do
    case live_action do
      :grid -> grid_lab()
      _ -> demo()
    end
  end

  defp get_default_command_builder(), do: fn step_id -> Command.new(100, step_id: step_id) end
end
