ExUnit.start()

defmodule CommandQueueTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Convert a 1-segment straight command into move segments" do
    actual_svg_path_string =
      Command.new(100, angle: 0)
      |> Command.generate_segments(1, Pose.origin())
      |> List.first()
      |> Segment.svg_path()
    assert "M 0 0 L 100 0" = actual_svg_path_string
  end

  test "Command queue enum supplies default commands" do
    command_queue = CommandQueue.new(1, get_default_command_builder())
    three_default_commands = command_queue |> Enum.take(3)
    assert 3 = Enum.count(three_default_commands)
    first_default_command = three_default_commands |> List.first()
    assert 100 = first_default_command.len
  end

  test "Get movement segments from default command queue" do
    command_queue = CommandQueue.new(1, get_default_command_builder())
    arena = Rect.new(450, 450)
    movement_segments = CommandQueue.build_segments(command_queue, Pose.new(0, 0, 0), arena)
    assert 5 = Enum.count(movement_segments)
  end

  test "Command Queue with one long staight produces correct number of segments" do
    len = %{default: 100, explicit: 200}
    nominal_arena_x_dim = 2 * (len |> Map.values |> Enum.sum)
    default_command_builder = fn step_id -> Command.new(len.default, step_id: step_id) end
    explicit_commands =
      1..2
      |> Enum.map(&(Command.new(len.explicit, id: &1, state: :in_hand)))
    deck = CommandQueue.new 1, default_command_builder, explicit_commands
    # Scenario 1
    arena = Rect.new(nominal_arena_x_dim - 1, 0)
    segments =
      deck
      |> CommandQueue.issue_command(CommandIds.new(1, 1, 2))
      |> CommandQueue.issue_command(CommandIds.new(1, 2, 4))
      |> CommandQueue.build_segments(Pose.origin(), arena)
    assert 4 = Enum.count segments
    # Scenario 2
    arena = Rect.new(nominal_arena_x_dim + 1, 0)
    segments =
      deck
      |> CommandQueue.issue_command(CommandIds.new(1, 1, 4))
      |> CommandQueue.issue_command(CommandIds.new(1, 2, 2))
      |> IOP.inspect("command queue!")
      |> CommandQueue.build_segments(Pose.origin(), arena)
      |> IOP.inspect("segments!")
    assert 5 = Enum.count segments
  end

  test "Build segments with multiple commands" do
    arena = Rect.new(450, 450)
    segments =
      deck()
      |> CommandQueue.issue_command(CommandIds.new(1, 2, 1))
      |> CommandQueue.build_segments(Pose.new(0, 0, 0), arena)
    assert 4 = Enum.count segments
  end
end
