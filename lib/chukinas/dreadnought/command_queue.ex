defmodule Chukinas.Dreadnought.CommandQueue do
  alias Chukinas.Dreadnought.{CommandQueue, Command, Segment, CommandIds}
  alias Chukinas.Geometry.{Pose, Rect}

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    # TODO rename just `commands`, now that I'm keeping all commands in a single list.
    # TODO also, that means I have to update the enumerable impl.
    # TODO convert this from list to map. I'll be accessing commands by id often
    field :commands, %{integer() => Command.t()}, default: %{}
    field :default_command_builder, (integer() -> Command.t())
  end

  # *** *******************************
  # *** NEW

  def new(id) do
    default_builder = fn seg_num -> Command.new(step_id: seg_num) end
    %__MODULE__{
      id: id,
      default_command_builder: default_builder
    }
  end

  def new(id, commands) do
    default_builder = fn seg_num -> Command.new(step_id: seg_num) end
    %__MODULE__{
      id: id,
      default_command_builder: default_builder
    }
    |> set_commands(commands)
  end

  # *** *******************************
  # *** GETTERS

  # TODO rename id
  def get_id(deck), do: deck.id
  def id(deck), do: deck.id

  def commands(%__MODULE__{commands: commands}) do
    commands
    |> Stream.filter(&Command.issued?/1)
    |> Enum.sort(&Command.sort_by_segment/2)
  end

  # *** *******************************
  # *** SETTERS

  def set_commands(%__MODULE__{} = deck, %{} = commands) do
    %{deck | commands: commands}
  end
  def set_commands(%__MODULE__{} = deck, commands) when is_list(commands) do
    command_map =
      commands
      |> Stream.map(fn cmd -> {cmd.id, cmd} end)
      |> Map.new()
      |> IOP.inspect("setting commands!!!!")
    %{deck | commands: command_map}
  end

  # *** *******************************
  # *** FILTERS

  def commands_as_stream(%__MODULE__{commands: commands}) do
    commands
    |> IOP.inspect
    |> Stream.map(fn {_id, command} -> command end)
  end

  def onpath_commands_as_list(%__MODULE__{} = command_queue) do
    command_queue
    |> commands_as_stream
    |> Enum.filter(&Command.on_path?/1)
  end

  # *** *******************************
  # *** API

  # TODO move this to SETTERS?
  def add( %__MODULE__{} = deck, %Command{} = command) do
    put_in(deck.commands[Command.id(command)], command)
  end

  @spec build_segments(t(), Pose.t(), Rect.t()) :: [Segment.t()]
  def build_segments(%__MODULE__{} = command_queue, %Pose{} = start_pose, %Rect{} = arena) do
    starts_inbounds? = get_inbounds_checker(arena)
    unit_id = CommandQueue.id(command_queue)
    generate_segments = fn command, start_pose ->
      Command.generate_segments(command, unit_id, start_pose)
    end
    command_queue
    |> Stream.scan(start_pose, generate_segments)
    |> Stream.take_while(starts_inbounds?)
    |> Stream.concat()
    |> Enum.to_list()
  end

  # TODO rename issue_command?
  @spec play_card(t(), CommandIds.t()) :: t()
  def play_card(
    %__MODULE__{id: id, commands: commands} = current_deck,
    # TODO segment needs renamed
    %CommandIds{unit: unit_id, segment: segment_id} = cmd
  ) when id == unit_id do
    IOP.inspect("play_card!!!")
    match? = fn command ->
      Command.id(command) == cmd.card and Command.playable?(command)
    end
    command =
      current_deck
      |> IOP.inspect("current deck!!!")
      |> commands_as_stream()
      |> IOP.inspect
      |> Enum.find(match?)
      |> Command.play(segment_id)
    commands =
      commands
      |> Map.put(Command.id(command), command)
    current_deck
    |> Map.put(:commands, commands)
  end

  # *** *******************************
  # *** PRIVATE

  defp get_inbounds_checker(arena) do
    fn segments ->
      pose = segments |> List.first() |> Segment.start_pose()
      arena |> Rect.contains?(pose)
    end
  end
end
