defmodule Chukinas.Dreadnought.Command.E do
  alias Chukinas.Dreadnought.Command
  alias Chukinas.Dreadnought.Vector

  # *** *******************************
  # *** TYPES

  @type t() :: [Command.t()]

  # *** *******************************
  # *** NEW

  def new(segment_numbers) do
    segment_numbers |> Enum.map(&(Command.new/1))
  end

  # *** *******************************
  # *** API

  # TODO which of these are private?
  def remove_at_segment(commands, segment_number) when is_list(commands) do
    {before_commands, [removed_command, after_commands]} = commands
    |> Enum.split_while(&(!Command.occupies_segment(&1, segment_number)))
    new_commands = Command.get_segment_numbers(removed_command) |> new()
    Enum.concat([before_commands, new_commands, after_commands])
  end

  def set_paths(commands, start_vector) when is_list(commands) do
    # flat map reduce
    {commands_with_paths, _final_end_vector} = commands
    |> Enum.map_reduce(start_vector, fn x, acc ->
      command = Command.set_path(x, acc)
      {command, command.vector_end}
    end)
    commands_with_paths
  end

end
