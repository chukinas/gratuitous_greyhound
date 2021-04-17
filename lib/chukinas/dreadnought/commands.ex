alias Chukinas.Dreadnought.{Command, Commands}
alias Chukinas.Geometry.Position

# TODO think up a better name for this
defmodule Commands do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :player_id, integer(), enforce: true
    field :active_unit_ids, [integer()], default: []
    field :commands, [Command.t()], default: []
    # For internal reference only (probably)
    field :my_unit_ids, [integer()], enforce: true
  end

  # *** *******************************
  # *** NEW

  def new(units, player_id) do
    %__MODULE__{
      player_id: player_id,
      my_unit_ids: get_list_my_unit_ids(units, player_id)
    }
    |> calc_active_units
  end

  # *** *******************************
  # *** API

  def maneuver(commands, unit_id, x, y) do
    command = Command.move_to(unit_id, Position.new(x, y))
    issue_command(commands, command)
  end

  defp issue_command(commands, command) do
    commands
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  def turn_complete?(commands), do: Enum.empty?(commands.active_unit_ids)

  # *** *******************************
  # *** PRIVATE

  defp get_list_my_unit_ids(units, player_id) do
    units
    |> Stream.map(& &1.player_id)
    |> Enum.filter(& &1 == player_id)
  end

  defp calc_active_units(commands) do
    %{commands | active_unit_ids: Enum.take(my_pending_unit_ids(commands), 1)}
  end

  defp my_pending_unit_ids(commands) do
    commands.commands
    |> Stream.map(& &1.unit_id)
    |> Stream.filter(& &1 in commands.my_unit_ids)
  end
end
