ExUnit.start()

defmodule CommandQueueTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Convert a 1-segment straight command into move segments" do
    actual_svg_path_string =
      Command.new(angle: 0, speed: 3)
      |> Command.generate_segments(1, Pose.origin())
      |> List.first()
      |> Segment.svg_path()
    assert "M 0 0 L 100 0" = actual_svg_path_string
  end

  test "Command queue enum supplies default commands" do
    command_queue = CommandQueue.new(1)
    three_default_commands = command_queue |> Enum.take(3)
    assert 3 = Enum.count(three_default_commands)
    first_default_command = three_default_commands |> List.first()
    assert 3 = first_default_command.speed
  end

  test "Get movement segments from default command queue" do
    command_queue = CommandQueue.new(1)
    arena = Rect.new(450, 450)
    movement_segments = CommandQueue.build_segments(command_queue, Pose.new(0, 0, 0), arena)
    assert 5 = Enum.count(movement_segments)
  end

  test "Command Queue with one long staight produces correct number of segments" do
    arena = Rect.new(450, 450)
    segments =
      deck()
      |> CommandQueue.play_card(CommandIds.new(1, 2, 1))
      |> CommandQueue.build_segments(Pose.new(0, 0, 0), arena)
    assert 4 = Enum.count segments
  end
end
