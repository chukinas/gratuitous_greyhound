alias Chukinas.Dreadnought.{Mission, Unit, Command, CommandQueue, CommandIds, MissionBuilder}
alias Chukinas.Geometry.{Pose, Polygon, Size}

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
    margin = Size.new(500, 500)
    Mission.new()
    |> Mission.set_grid(50, 20, 15, margin)
    |> Mission.set_overlapping_squares(Polygon.new [{0, 0}, {200, 0}, {0, 330}])
    |> Mission.set_unit(Unit.new(1) |> Unit.set_position(margin))
  end

  def from_live_action(live_action) do
    case live_action do
      :grid -> grid_lab()
      _ -> demo()
    end
  end

  defp get_default_command_builder(), do: fn step_id -> Command.new(100, step_id: step_id) end
end
