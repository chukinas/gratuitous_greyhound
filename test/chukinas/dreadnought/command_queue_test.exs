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
    # TODO I don't like th name move segment...
    move_segment = command |> Command.generate_segments(start_pose) |> List.first()
    expected_position = start_pose |> Point.new() |> Position.subtract(get_margin())
    assert match_numerical_map? expected_position, move_segment.position
    assert "-10 -10 120 20" = move_segment.svg_viewbox
    assert "M 0 0 L 100 0" = move_segment.svg_path
  end

  test "Get movement segments from default command queue" do
    command_queue = CommandQueue.new()
    arena = Rect.new(450, 450)
    movement_segments = Segments.init(command_queue, Pose.new(0, 0, 0), arena)
    assert 5 = Enum.count(movement_segments)
  end
end
