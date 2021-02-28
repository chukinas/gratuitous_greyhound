alias Chukinas.Dreadnought.{CommandQueue, Command, Segment}
alias Chukinas.Geometry.Rect
defmodule CommandQueue do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :issued_commands, [Command.t()], default: []
    field :default_command_builder, (integer() -> Command.t())
  end

  # *** *******************************
  # *** NEW

  def new(id) do
    default_builder = fn seg_num -> Command.new(segment_number: seg_num) end
    %__MODULE__{
      id: id,
      default_command_builder: default_builder
    }
  end

  # *** *******************************
  # *** GETTERS

  def get_id(deck), do: deck.id

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

  def build_segments(command_queue, start_pose, arena) do
    starts_inbounds? = get_inbounds_checker(arena)
    command_queue
    |> Stream.scan(start_pose, &Command.generate_segments/2)
    |> Stream.take_while(starts_inbounds?)
    |> Stream.concat()
    |> Enum.to_list()
  end

  def play_card(deck, command) do
    {command, deck}
  end

  # *** *******************************
  # *** PRIVATE

  defp get_inbounds_checker(arena) do
    fn segments ->
      pose = segments |> List.first() |> Segment.get_start_pose()
      arena |> Rect.contains?(pose)
    end
  end
end
