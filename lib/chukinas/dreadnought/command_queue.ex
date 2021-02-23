alias Chukinas.Dreadnought.{CommandQueue, Command}

defmodule CommandQueue do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :issued_commands, [Command.t()], default: []
    field :default_command, Command.t()
    # For use in the enumerable implementation
    field :segment_counter, integer(), default: 1
  end

  # *** *******************************
  # *** NEW

  def new() do
    %__MODULE__{
      # TODO there should be a default command function. Maybe the default command doesn't require a segment number. In the meantime, I'm passing a negative number in here. It won't be used anyway.
      default_command: Command.new(),
    }
  end

  # *** *******************************
  # *** API

  def add(
    %__MODULE__{} = command_queue,
    %Command{segment_count: 1, segment_number: segment} = command
  ) do
    {earlier_cmds, later_cmds} =
      command_queue.issued_commands
      |> Enum.split_while(fn cmd -> cmd.segment_number < segment end)
    {_, later_cmds} =
      later_cmds
      |> Enum.split_while(fn cmd -> cmd.segment_number == segment end)
    cmds = Enum.concat([earlier_cmds, [command], later_cmds])
    %{command_queue | issued_commands: cmds}
  end
end
