defmodule Chukinas.Dreadnought.Command do
  alias Chukinas.Dreadnought.Vector

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :speed, integer(), default: 3
    field :angle, integer(), default: 0
    field :segment_number, integer()
    field :segment_count, integer(), default: 1
    field :type, atom(), default: :default
    field :vector_start, Vector.t(), enforce: false
    field :vector_end, Vector.t(), enforce: false
  end

  # *** *******************************
  # *** NEW

  def new(segment_number) do
    %__MODULE__{
      segment_number: segment_number,
    }
  end

  # *** *******************************
  # *** COMMAND OPERATIONS

  # TODO make note about how segments are listed from later (future) to oldest (past)
  defp get_segment_numbers(command) do
    min_segment = command.segment_number
    max_segment = command.segment_number + command.segment_count - 1
    min_segment..max_segment
  end

  defp occupies_segment(command, segment_number) do
    segment_number in get_segment_numbers(command)
  end

  # *** *******************************
  # *** LIST OPERATIONS

  def remove_at_segment(commands, segment_number) when is_list(commands) do
    {before_commands, [removed_command, after_commands]} = commands
    |> Enum.split_while(&(!occupies_segment(&1, segment_number)))
    new_commands = get_segment_numbers(removed_command) |> Enum.map(&new/1)
    Enum.concat([before_commands, new_commands, after_commands])
  end

  def set_path(commands, start_vector) when is_list(commands) do
    # flat map reduce
    IO.inspect(start_vector)
    {commands_with_paths, _final_end_vector} = commands
    |> Enum.map_reduce(start_vector, fn x, acc ->
      command = set_path(x, acc) |> IO.inspect()
      {command, command.vector_end}
    end)
    commands_with_paths
  end

  def set_path(%__MODULE__{angle: 0, speed: 3} = command, %Vector{} = start_vector) do
    command
    |> Map.put(:vector_start, start_vector)
    |> Map.put(:vector_end, Vector.move_straight(start_vector, 100))
  end

end
