alias Chukinas.Dreadnought.{UnitAction, PlayerActions, Unit}
alias Chukinas.Geometry.Position

# TODO think up a better name for this - ActionSelection again?
defmodule PlayerActions do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :player_id, integer()
    # TODO rename actions
    field :commands, [UnitAction.t()], default: []
    # For internal reference only (probably)
    field :player_active_unit_ids, [integer()]
    field :gunnery_targets, [integer()], default: [2, 3]
    field :current_unit_id, integer(), enforce: false
    field :current_mode, UnitAction.mode(), enforce: false
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
    |> IOP.inspect("new player actions", show_if: &(&1.player_id == 1))
  end

  # *** *******************************
  # *** GETTERS

  # TODO rename unit_actions
  def commands(%__MODULE__{commands: commands}), do: commands
  # TODO where used?
  def actions_available?(action_selection), do: action_selection.current_unit_id != nil
  def turn_complete?(action_selection), do: action_selection.current_unit_id == nil
  def pending_player_unit_ids(player_actions) do
    player_actions.player_active_unit_ids
    |> Stream.filter(& &1 not in my_completed_unit_ids(player_actions))
  end
  def count_player_active_units(player_actions) do
    Enum.count(player_actions.player_active_unit_ids)
  end
  def all_required_actions(player_actions) do
    Stream.flat_map(player_actions.player_active_unit_ids, fn unit_id ->
      [:maneuver, :combat]
      |> Stream.map(&{unit_id, &1})
    end)
  end
  def pending_actions(player_actions) do
    completed_actions =
      player_actions.commands
      |> Enum.map(&UnitAction.id_and_mode/1)
    player_actions
    |> all_required_actions
    |> Stream.filter(& &1 not in completed_actions)
    |> Stream.concat([{nil, nil}])
  end
  def next_pending_action(player_actions) do
    player_actions
    |> pending_actions
    |> Enum.take(1)
    |> List.first
  end
  def current_unit_id(%{current_unit_id: id}), do: id

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
    |> IOP.inspect("player actions after put", show_if: &(&1.player_id == 1))
  end

  # *** *******************************
  # *** PLAYER-ISSUED COMMANDS

  def maneuver(player_actions, unit_id, x, y) do
    command = UnitAction.move_to(unit_id, Position.new(x, y))
    put(player_actions, command)
  end

  def select_gunnery_target(player_actions, target_unit_id) when is_integer(target_unit_id) do
    unit_id = current_unit_id(player_actions)
    action = UnitAction.fire_upon(unit_id, target_unit_id)
    player_actions |> put(action)
  end

  # *** *******************************
  # *** PRIVATE

  defp calc_active_units(player_actions) do
    {id, mode} = next_pending_action(player_actions)
    %{player_actions |
      current_unit_id: id,
      current_mode: mode
    }
  end

  # TODO rename completed_player_unit_ids
  defp my_completed_unit_ids(player_actions) do
      player_actions.commands
      |> Stream.map(& &1.unit_id)
  end
end
