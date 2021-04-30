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
  def turn_complete?(player_actions) do
    Enum.empty?(player_actions.active_unit_ids)
  end

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = player_actions, list) when is_list(list) do
    Enum.reduce(list, player_actions, fn item, player_actions ->
      player_actions |> put(item)
    end)
  end
  def put(%__MODULE__{} = player_actions, %UnitAction{} = command) do
    player_actions
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  # *** *******************************
  # *** PLAYER-ISSUED COMMANDS

  def maneuver(player_actions, unit_id, x, y) do
    command = UnitAction.move_to(unit_id, Position.new(x, y))
    put(player_actions, command)
  end

  def select_gunnery_target(player_actions, _unit_id, _target_unit_id) do
    # TODO implement
    player_actions
  end

  # *** *******************************
  # *** PRIVATE

  # TODO private?
  def calc_active_units(player_actions) do
    %{player_actions | active_unit_ids: Enum.take(pending_player_unit_ids(player_actions), 1)}
  end

  # TODO rename completed_player_unit_ids
  defp my_completed_unit_ids(player_actions) do
      player_actions.commands
      |> Stream.map(& &1.unit_id)
  end
end
