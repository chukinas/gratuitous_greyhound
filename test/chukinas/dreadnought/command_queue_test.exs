alias Chukinas.Dreadnought.{CommandQueue, CommandQueueTest}

ExUnit.start()

defmodule CommandQueueTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Command queue enum supplies default commands" do
    command_queue = CommandQueue.new()
    three_default_commands = command_queue |> Enum.take(3) |> IO.inspect()
    assert 3 = Enum.count(three_default_commands)
    first_default_command = three_default_commands |> List.first()
    assert 3 = first_default_command.speed
  end
end
