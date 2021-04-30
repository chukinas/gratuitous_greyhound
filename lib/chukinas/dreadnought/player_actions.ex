alias Chukinas.Dreadnought.{UnitAction, PlayerActions, Unit}
alias Chukinas.Geometry.Position

# TODO think up a better name for this
defmodule PlayerActions do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  # TODO enforce: true
  typedstruct do
    field :player_id, integer(), enforce: true
    field :active_unit_ids, [integer()], default: []
    field :commands, [UnitAction.t()], default: []
    # For internal reference only (probably)
    field :player_active_unit_ids, [integer()], enforce: true
  end

  # *** *******************************
  # *** NEW

  # TODO refactor - player id comes first
  def new(units, player_id) do
    %__MODULE__{
      player_id: player_id,
      player_active_unit_ids: Unit.Enum.active_player_unit_ids(units, player_id)
    }
    |> calc_active_units
  end

  # *** *******************************
  # *** GETTERS

  # TODO rename unit_actions
  def commands(%__MODULE__{commands: commands}), do: commands
  def actions_available?(actions) do
    !Enum.empty?(actions.active_unit_ids)
  end
  def pending_player_unit_ids(player_actions) do
    player_actions.player_active_unit_ids
    |> Stream.filter(& &1 not in my_completed_unit_ids(player_actions))
  end


  # *** *******************************
  # *** SETTERS

  # TODO delete
  def put_commands(%__MODULE__{} = player_actions, commands) do
    %{player_actions | commands: commands ++ player_actions.commands}
    |> calc_active_units
  end

  # TODO rename put
  defp put_command(player_actions, command) do
    player_actions
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  # *** *******************************
  # *** COMMANDS

  # TODO delete
  def maneuver(player_actions, unit_id, x, y) do
    command = UnitAction.move_to(unit_id, Position.new(x, y))
    put_command(player_actions, command)
  end

  # TODO delete
  def exit_or_run_aground(player_actions, unit_id) do
    command = UnitAction.exit_or_run_aground(unit_id)
    put_command(player_actions, command)
  end

  # *** *******************************
  # *** BOOLEAN

  def turn_complete?(player_actions) do
    Enum.empty?(player_actions.active_unit_ids)
  end

  # *** *******************************
  # *** PRIVATE

  def calc_active_units(player_actions) do
    %{player_actions | active_unit_ids: Enum.take(pending_player_unit_ids(player_actions), 1)}
  end

  # TODO rename completed_player_unit_ids
  defp my_completed_unit_ids(player_actions) do
      player_actions.commands
      |> Stream.map(& &1.unit_id)
  end
end
