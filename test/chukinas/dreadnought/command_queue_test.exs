ExUnit.start()

defmodule CommandQueueTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Command queue enum supplies default commands" do
    command_queue = CommandQueue.new()
    three_default_commands = command_queue |> Enum.take(3)
    assert 3 = Enum.count(three_default_commands)
    first_default_command = three_default_commands |> List.first()
    assert 3 = first_default_command.speed
  end

  test "Convert a 1-segment straight command into move segments" do
    command = Command.new()
    start_pose = Pose.new(0, 0, 0)
    segment = command |> Command.generate_segments(start_pose) |> List.first()
    assert "M 0 0 L 100 0" = segment.svg_path
  end

  test "Get movement segments from default command queue" do
    command_queue = CommandQueue.new()
    arena = Rect.new(450, 450)
    movement_segments = CommandQueue.build_segments(command_queue, Pose.new(0, 0, 0), arena)
    assert 5 = Enum.count(movement_segments)
  end

  test "Command Queue with one long staight produces correct number of segments" do
    arena = Rect.new(450, 450)
    segments =
      CommandQueue.new()
      |> CommandQueue.add(Command.new(speed: 5, segment_number: 2))
      |> CommandQueue.build_segments(Pose.new(0, 0, 0), arena)
    assert 4 = Enum.count segments
  end
end
