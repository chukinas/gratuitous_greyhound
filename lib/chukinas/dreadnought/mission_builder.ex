alias Chukinas.Dreadnought.{Mission, Unit, Command, CommandQueue, CommandIds, MissionBuilder}
alias Chukinas.Geometry.{Pose, Size}

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
    margin = Size.new(3000 / 2, 2000)
    unit = Unit.new(Enum.random(1..1000), pose: Pose.new(100, 100, 45)) |> Unit.set_position(margin)
    motion_range_polygon = Unit.get_motion_range unit
    Mission.new()
    |> Mission.set_grid(30, 100, 75, margin)
    |> Mission.set_overlapping_squares(motion_range_polygon)
    |> Mission.set_unit(unit)
  end

  def from_live_action(live_action) do
    case live_action do
      :grid -> grid_lab()
      _ -> demo()
    end
  end

  defp get_default_command_builder(), do: fn step_id -> Command.new(100, step_id: step_id) end
end
