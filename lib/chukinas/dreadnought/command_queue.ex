defmodule Chukinas.Dreadnought.CommandQueue do
  alias Chukinas.Dreadnought.{CommandQueue, Command, Segment, CommandIds}
  alias Chukinas.Geometry.{Pose, Rect}

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
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

  def id(deck), do: deck.id

  def commands(%__MODULE__{commands: commands}) do
    commands
    |> Stream.filter(&Command.issued?/1)
    |> Enum.sort(&Command.sort_by_segment/2)
  end

  # *** *******************************
  # *** SETTERS

  def add(%__MODULE__{} = deck, [command | []]) do
    add deck, command
  end
  def add(%__MODULE__{} = deck, [command | commands]) do
    new_deck = add deck, command
    add new_deck, commands
  end
  def add( %__MODULE__{} = deck, %Command{} = command) do
    put_in(deck.commands[Command.id(command)], command)
  end

  def set_commands(%__MODULE__{} = deck, %{} = commands) do
    %{deck | commands: commands}
  end
  def set_commands(%__MODULE__{} = deck, commands) when is_list(commands) do
    command_map =
      commands
      |> Stream.map(fn cmd -> {cmd.id, cmd} end)
      |> Map.new()
    %{deck | commands: command_map}
  end

  # *** *******************************
  # *** FILTERS

  def commands_as_stream(%__MODULE__{commands: commands}) do
    commands
    |> Stream.map(fn {_id, command} -> command end)
  end

  def onpath_commands_as_list(%__MODULE__{} = command_queue) do
    command_queue
    |> commands_as_stream
    |> Enum.filter(&Command.on_path?/1)
  end

  # *** *******************************
  # *** API

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

  @spec issue_command(t(), CommandIds.t()) :: t()
  def issue_command(
    %__MODULE__{id: id, commands: commands} = current_deck,
    %CommandIds{unit: unit_id, step: step} = cmd
  ) when id == unit_id do
    match? = fn command ->
      Command.id(command) == cmd.card and Command.playable?(command)
    end
    command =
      current_deck
      |> commands_as_stream()
      |> Enum.find(match?)
      |> Command.play(step)
    commands =
      commands
      |> Map.put(Command.id(command), command)
    current_deck
    |> Map.put(:commands, commands)
  end

  def draw(%__MODULE__{} = deck, count) when is_integer(count) do
    drawn_commands =
      deck
      |> commands_as_stream
      |> Stream.filter(&Command.in_draw_pile?/1)
      |> Stream.map(&Command.draw/1)
      |> Stream.take(count)
      |> Enum.to_list
      |> IOP.inspect("there should be 5 drawn cards here")
    add deck, drawn_commands
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
