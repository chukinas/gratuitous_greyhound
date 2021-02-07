defmodule Chukinas.Dreadnought.Command do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :speed, integer(), default: 3
    field :angle, integer(), default: 0
    field :segment_number, integer()
    field :segment_count, integer(), default: 1
    field :type, atom(), default: :default
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

  def occupies_segment(command, segment_number) do
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

end
