alias Chukinas.Dreadnought.{Command, ActionSelection, Unit}
alias Chukinas.Geometry.Position

# TODO think up a better name for this
defmodule ActionSelection do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :player_id, integer(), enforce: true
    field :active_unit_ids, [integer()], default: []
    field :commands, [Command.t()], default: []
    # For internal reference only (probably)
    # TODO think of better name
    field :my_unit_ids, [integer()], enforce: true
  end

  # *** *******************************
  # *** NEW

  # TODO refactor - player id comes first
  def new(units, player_id) do
    %__MODULE__{
      player_id: player_id,
      my_unit_ids: get_list_my_unit_ids(units, player_id)
    }
    |> calc_active_units
  end

  # *** *******************************
  # *** SETTERS

  def put_commands(%__MODULE__{} = action_selection, commands) do
    %{action_selection | commands: commands}
    |> calc_active_units
  end

  defp put_command(action_selection, command) do
    action_selection
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  # *** *******************************
  # *** COMMANDS

  def maneuver(action_selection, unit_id, x, y) do
    command = Command.move_to(unit_id, Position.new(x, y))
    put_command(action_selection, command)
  end

  def exit_or_run_aground(action_selection, unit_id) do
    command = Command.exit_or_run_aground(unit_id)
    put_command(action_selection, command)
  end

  # *** *******************************
  # *** BOOLEAN

  def turn_complete?(action_selection) do
    Enum.empty?(action_selection.active_unit_ids)
  end

  # *** *******************************
  # *** PRIVATE

  defp get_list_my_unit_ids(units, player_id) do
    units
    |> Enum.filter(&Unit.belongs_to?(&1, player_id))
    |> Enum.map(& &1.id)
  end

  defp calc_active_units(action_selection) do
    %{action_selection | active_unit_ids: Enum.take(my_pending_unit_ids(action_selection), 1)}
  end

  defp my_pending_unit_ids(action_selection) do
    action_selection.my_unit_ids
    |> Stream.filter(& &1 not in my_completed_unit_ids(action_selection))
  end

  defp my_completed_unit_ids(action_selection) do
      action_selection.commands
      |> Stream.map(& &1.unit_id)
  end
end
