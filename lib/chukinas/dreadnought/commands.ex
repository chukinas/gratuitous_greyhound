alias Chukinas.Dreadnought.{Command, ActionSelection}
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

  def maneuver(action_selection, unit_id, x, y) do
    command = Command.move_to(unit_id, Position.new(x, y))
    issue_command(action_selection, command)
  end

  defp issue_command(action_selection, command) do
    action_selection
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  def turn_complete?(action_selection) do
    Enum.empty?(action_selection.active_unit_ids)
  end

  # *** *******************************
  # *** PRIVATE

  defp get_list_my_unit_ids(units, player_id) do
    units
    |> Stream.map(& &1.player_id)
    |> Enum.filter(& &1 == player_id)
  end

  defp calc_active_units(action_selection) do
    %{action_selection | active_unit_ids: Enum.take(my_pending_unit_ids(action_selection), 1)}
    |> IOP.inspect("my pending unit ids")
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
