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

  @tag pita: true
  test "Convert a 1-segment straight command into move segments" do
    command = Command.new()
    start_pose = Pose.new(0, 0, 0)
    segment = command |> Command.generate_segments(start_pose) |> List.first()
    assert "-10 -10 120 20" = segment.svg_viewbox
    assert "M 0 0 L 100 0" = segment.svg_path
  end

  test "Get movement segments from default command queue" do
    command_queue = CommandQueue.new()
    arena = Rect.new(450, 450)
    movement_segments = Segments.init(command_queue, Pose.new(0, 0, 0), arena)
    assert 5 = Enum.count(movement_segments)
  end
end
