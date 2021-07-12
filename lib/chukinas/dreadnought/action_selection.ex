defmodule Chukinas.Dreadnought.ActionSelection do

  alias Chukinas.Dreadnought.ActionSelection.Maneuver
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Dreadnought.UnitAction
  alias Chukinas.Geometry.GridSquare

  # *** *******************************
  # *** TYPES

  use Chukinas.PositionOrientationSize

  typedstruct enforce: true do
    field :player_id, integer()
    field :actions, [UnitAction.t()], default: []
    field :player_active_unit_ids, [integer()]
    field :enemy_unit_ids, [integer()]
    field :current_unit_id, integer(), enforce: false
    field :current_mode, UnitAction.mode(), enforce: false
    field :current_target_unit_ids, [integer()], default: []
    # TODO make a protocol for this
    field :current_action_selection, Maneuver | nil, enforce: false
    field :maneuver_squares, [GridSquare], default: []
  end

  # *** *******************************
  # *** NEW

  def new(player_id, units, maneuver_squares) do
    %__MODULE__{
      player_id: player_id,
      enemy_unit_ids: Unit.Enum.enemy_unit_ids(units, player_id),
      player_active_unit_ids: Unit.Enum.active_player_unit_ids(units, player_id),
      maneuver_squares: maneuver_squares
    }
    |> calc_current
  end

  # *** *******************************
  # *** GETTERS

  def actions(%__MODULE__{actions: value}), do: value

  def current_mode(%__MODULE__{current_mode: value}), do: value

  def current_unit_id(%__MODULE__{current_unit_id: value}), do: value

  def maneuver_squares(%__MODULE__{maneuver_squares: value}), do: value

  def completed_player_unit_ids(action_selection) do
    action_selection
    |> actions
    |> Stream.map(& &1.unit_id)
  end
  def pending_player_unit_ids(action_selection) do
    action_selection.player_active_unit_ids
    |> Stream.filter(& &1 not in completed_player_unit_ids(action_selection))
  end
  def count_player_active_units(action_selection) do
    Enum.count(action_selection.player_active_unit_ids)
  end
  def all_required_actions(action_selection) do
    Stream.flat_map(action_selection.player_active_unit_ids, fn unit_id ->
      [:maneuver, :combat]
      |> Stream.map(&{unit_id, &1})
    end)
  end
  def pending_actions(action_selection) do
    completed_actions =
      action_selection
      |> actions
      |> Enum.map(&UnitAction.id_and_mode/1)
    action_selection
    |> all_required_actions
    |> Stream.filter(& &1 not in completed_actions)
    |> Stream.concat([{nil, nil}])
  end
  def next_pending_action(action_selection) do
    action_selection
    |> pending_actions
    |> Enum.take(1)
    |> List.first
  end

  # Booleans
  def turn_complete?(action_selection), do: action_selection.current_unit_id == nil
  def combat?(%{current_mode: :combat}), do: true
  def combat?(_), do: false

  def maneuver_squares_for_current_unit(action_selection) do
    unit_id = current_unit_id(action_selection)
    action_selection
    |> maneuver_squares
    |> Enum.filter(& &1.unit_id == unit_id)
  end

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = action_selection, list) when is_list(list) do
    Enum.reduce(list, action_selection, fn item, action_selection ->
      action_selection |> put(item)
    end)
  end
  def put(%__MODULE__{} = action_selection, %UnitAction{} = command) do
    action_selection
    |> Map.update!(:actions, & [command | &1])
    |> calc_current
  end

  # *** *******************************
  # *** PLAYER-ISSUED ACTIONS

  # TODO move this to Maneuver action selection?
  def maneuver(action_selection, unit_id, x, y) do
    command = UnitAction.move_to(unit_id, position(x, y))
    put(action_selection, command)
  end

  def select_gunnery_target(action_selection, target_unit_id) when is_integer(target_unit_id) do
    unit_id = current_unit_id(action_selection)
    action = UnitAction.fire_upon(unit_id, target_unit_id)
    action_selection |> put(action)
  end

  # *** *******************************
  # *** PRIVATE

  defp calc_current(action_selection) do
    action_selection
    |> calc_current_action
    |> calc_current_targets
    |> maybe_combat_noop
  end
  defp calc_current_action(action_selection) do
    {id, mode} = next_pending_action(action_selection)
    %__MODULE__{action_selection |
      current_unit_id: id,
      current_mode: mode
    }
    |> maybe_put_maneuver
  end

  defp calc_current_targets(action_selection) do
    targets = if combat?(action_selection), do: action_selection.enemy_unit_ids, else: []
    %__MODULE__{action_selection | current_target_unit_ids: targets}
  end

  defp maybe_combat_noop(%{
    current_target_unit_ids: targets,
    current_unit_id: unit_id
  } = action_selection) do
    if Enum.empty?(targets) and combat?(action_selection) do
      action_selection
      |> put(UnitAction.combat_noop(unit_id))
      |> calc_current
    else
      action_selection
    end
  end

  defp maybe_put_maneuver(action_selection) do
    current_action_selection = case current_mode(action_selection) do
      :maneuver ->
        # TODO this is pretty ugly
        squares = maneuver_squares_for_current_unit(action_selection)
        case Enum.count(squares) do
          0 -> nil
          _ -> Maneuver.new(current_unit_id(action_selection), squares)
        end
      _ ->
        nil
    end
    %__MODULE__{action_selection | current_action_selection: current_action_selection}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    require IOP
    def inspect(actionsel, opts) do
      fields = [
        actions: actionsel.actions,
        enemies: actionsel.current_target_unit_ids
      ]
      IOP.struct("#Player-#{actionsel.player_id}-Actions", fields)
    end
  end
end
