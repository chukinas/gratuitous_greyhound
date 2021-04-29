alias Chukinas.Dreadnought.{UnitOrders, PlayerActions, Unit}
alias Chukinas.Geometry.Position

# TODO think up a better name for this
defmodule PlayerActions do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :player_id, integer(), enforce: true
    field :active_unit_ids, [integer()], default: []
    field :commands, [UnitOrders.t()], default: []
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
      my_unit_ids: player_unit_ids(units, player_id)
    }
    |> calc_active_units
  end

  # *** *******************************
  # *** GETTERS

  def commands(%__MODULE__{commands: commands}), do: commands

  # *** *******************************
  # *** SETTERS

  def put_commands(%__MODULE__{} = player_actions, commands) do
    %{player_actions | commands: commands ++ player_actions.commands}
    |> calc_active_units
  end

  defp put_command(player_actions, command) do
    player_actions
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  # *** *******************************
  # *** COMMANDS

  def maneuver(player_actions, unit_id, x, y) do
    command = UnitOrders.move_to(unit_id, Position.new(x, y))
    put_command(player_actions, command)
  end

  def exit_or_run_aground(player_actions, unit_id) do
    command = UnitOrders.exit_or_run_aground(unit_id)
    put_command(player_actions, command)
  end

  # *** *******************************
  # *** BOOLEAN

  def turn_complete?(player_actions) do
    Enum.empty?(player_actions.active_unit_ids)
  end

  # *** *******************************
  # *** PRIVATE

  def player_unit_ids(units, player_id) do
    units
    |> Enum.filter(&Unit.belongs_to?(&1, player_id))
    |> Enum.map(& &1.id)
  end

  defp calc_active_units(player_actions) do
    %{player_actions | active_unit_ids: Enum.take(my_pending_unit_ids(player_actions), 1)}
  end

  defp my_pending_unit_ids(player_actions) do
    player_actions.my_unit_ids
    |> Stream.filter(& &1 not in my_completed_unit_ids(player_actions))
  end

  defp my_completed_unit_ids(player_actions) do
      player_actions.commands
      |> Stream.map(& &1.unit_id)
  end
end
