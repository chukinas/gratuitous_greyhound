alias Chukinas.Dreadnought.{CommandQueue, Command, Segment, CommandIds}
alias Chukinas.Geometry.{Pose, Rect}
defmodule CommandQueue do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    # TODO rename just `commands`, now that I'm keeping all commands in a single list.
    # TODO also, that means I have to update the enumerable impl.
    # TODO convert this from list to map. I'll be accessing commands by id often
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

  @spec build_segments(t(), Pose.t(), Rect.t()) :: [Segment.t()]
  def build_segments(%__MODULE__{} = command_queue, %Pose{} = start_pose, %Rect{} = arena) do
    starts_inbounds? = get_inbounds_checker(arena)
    command_queue
    |> Stream.scan(start_pose, &Command.generate_segments/2)
    |> Stream.take_while(starts_inbounds?)
    |> Stream.concat()
    |> Enum.to_list()
  end

  # TODO rename issue_command?
  @spec play_card(t(), CommandIds.t()) :: t()
  def play_card(
    %__MODULE__{issued_commands: commands} = current_deck,
    %CommandIds{segment: segment_id} = cmd
  ) do
    match? = fn command ->
      Command.id(command) == cmd.card and Command.playable?(command)
    end
    command =
      commands
      |> Enum.find(match?)
      |> Command.play(segment_id)
    new_commands =
      commands
      |> Enum.reject(match?)
      |> Enum.concat([command])
    current_deck
    |> Map.put(:issued_commands, new_commands)
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
