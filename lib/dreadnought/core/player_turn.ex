# TODO this name should match that of the Dyn World comp. Change this one or both to match
defmodule Dreadnought.Core.PlayerTurn do
  @moduledoc """
  Holds the information needed for a single player taking his turn

  It is regenerated for each new turn.
  """

  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.ManeuverPlanning
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.Unit
  alias Dreadnought.Core.UnitAction
  alias Dreadnought.Geometry.GridSquare

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :player, Player.t
    field :action_selection, ActionSelection.t()
    # TODO get rid of this field eventually
    field :cmd_squares, [GridSquare.t()], default: []
    field :show_end_turn_btn?, boolean(), default: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(%Mission{} = mission, player_uuid) when is_binary(player_uuid) do
    grid = Mission.grid(mission)
    islands = Mission.islands(mission)
    units = Mission.units(mission)
    player = Mission.player_by_uuid(mission, player_uuid)
    player_id = Player.id(player)
    squares = cmd_squares(units, player_id, grid, islands)
    %__MODULE__{
      player: player,
      action_selection: ActionSelection.new(player_id, units, squares)
    }
    |> put_maneuver_squares(squares)
    |> maneuver_trapped_units
    |> if_ai_calc_commands
    |> determine_show_end_turn_btn
    # TODO make us of this terminology elsewhere
    # 'trapped' means the unit would normally be allowed to receive a move-to action,
    # but in this case it's jammed up against the side of the board or an island and will
    # leave the game next turn
  end

  # *** *******************************
  # *** REDUCERS

  # TODO pattern match on __MODULE__
  def update_action_selection(player_turn, fun) do
    Map.update!(player_turn, :action_selection, fun)
  end

  # *** *******************************
  # *** REDUCERS (PRIVATE)

  defp put_maneuver_squares(player_turn, squares) do
    %__MODULE__{player_turn | cmd_squares: squares}
  end

  defp maneuver_trapped_units(%__MODULE__{
    cmd_squares: cmd_squares,
    action_selection: action_selection
  } = player_turn) do
    unit_ids_that_have_cmd_squares = MapSet.new(cmd_squares, & &1.unit_id)
    trapped_unit_id? = fn id when is_integer(id) ->
      !MapSet.member?(unit_ids_that_have_cmd_squares, id)
    end
    unit_actions =
      action_selection
      |> ActionSelection.pending_player_unit_ids
      |> Stream.filter(trapped_unit_id?)
      |> Enum.map(&UnitAction.exit_or_run_aground/1)
    Map.update!(player_turn, :action_selection, &ActionSelection.put(&1, unit_actions))
  end

  defp determine_show_end_turn_btn(%__MODULE__{} = player_turn) do
    show? = player_turn.action_selection |> ActionSelection.turn_complete?
    %__MODULE__{player_turn | show_end_turn_btn?: show?}
  end

  # TODO move the bulk of this out to the AI module
  defp if_ai_calc_commands(player_turn) do
    if ai_player?(player_turn) do
      #player_turn = Map.put(player_turn, :maneuver_foresight, 4)
      pending_unit_ids =
        player_turn.action_selection
        |> ActionSelection.pending_player_unit_ids
      unit_maneuvers = Enum.map(pending_unit_ids, fn unit_id ->
        position =
          player_turn.cmd_squares
          |> Stream.filter(fn %GridSquare{unit_id: id} -> id == unit_id end)
          |> Enum.random
          |> GridSquare.position
        UnitAction.move_to(unit_id, position)
      end)
      Map.update!(player_turn, :action_selection, &ActionSelection.put(&1, unit_maneuvers))
    else
      player_turn
    end
  end

  # *** *******************************
  # *** PRIVATE
  # TODO is there a better place to put this?

  defp cmd_squares(units, player_id, grid, islands) do
    units
    |> Unit.Enum.active_player_units(player_id)
    |> Enum.flat_map(&ManeuverPlanning.get_cmd_squares(&1, grid, islands, 1))
  end

  # *** *******************************
  # *** CONVERTERS

  def action_selection(%__MODULE__{action_selection: value}), do: value

  def ai_player?(%__MODULE__{} = player_turn) do
    player_turn
    |> player
    |> Player.ai?
  end

  def player(%__MODULE__{player: value}), do: value

  def player_id(%__MODULE__{} = player_turn) do
    player_turn
    |> player
    |> Player.uuid
  end

  def player_uuid(%__MODULE__{} = player_turn) do
    player_turn
    |> player
    |> Player.uuid
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(player, opts) do
      summary = %{
        action_selection: player.action_selection,
      }
     concat ["#Player-#{player.player_id}<", to_doc(summary, opts), ">"]
    end
  end
end
