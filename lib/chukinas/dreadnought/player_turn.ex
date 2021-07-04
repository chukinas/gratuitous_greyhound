# TODO this name should match that of the Dyn World comp. Change this one or both to match
defmodule Chukinas.Dreadnought.PlayerTurn do
  @moduledoc """
  Holds the information needed for a single player taking his turn

  It is regenerated for each new turn.
  """

  alias Chukinas.Dreadnought.ActionSelection
  alias Chukinas.Dreadnought.ManeuverPlanning
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Dreadnought.UnitAction
  alias Chukinas.Geometry.GridSquare

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :player_id, integer()
    field :player_type, any()
    field :player_actions, ActionSelection.t()
    field :cmd_squares, [GridSquare.t()], default: []
    field :show_end_turn_btn?, boolean(), default: false
  end

  # *** *******************************
  # *** NEW

  def new(player_id, player_type, %{
    islands: islands,
    grid: grid,
    units: units
  } = mission) do
    squares = cmd_squares(units, player_id, grid, islands)
    mission
    |> Map.take([
    ])
    |> Map.merge(%{
      player_id: player_id,
      player_type: player_type,
      player_actions: ActionSelection.new(player_id, units, squares)
    })
    |> build_struct
    |> put_maneuver_squares(squares)
    |> maneuver_trapped_units
    |> if_ai_calc_commands
    |> determine_show_end_turn_btn
    # TODO make us of this terminology elsewhere
    # 'trapped' means the unit would normally be allowed to receive a move-to action,
    # but in this case it's jammed up against the side of the board or an island and will
    # leave the game next turn
  end

  # TODO remove. Keep this as a struct?
  def map(player_id, player_type, mission) do
    Map.from_struct(new(player_id, player_type, mission))
  end

  # TODO remove. Keep this as a struct always?
  defp build_struct(map), do: struct!(__MODULE__, map)

  # *** *******************************
  # *** GETTERS

  def foresight(%__MODULE__{player_type: :ai}), do: 3
  def foresight(_), do: 1

  # *** *******************************
  # *** API

  # TODO pattern match on __MODULE__
  def update_action_selection(player_turn, fun) do
    Map.update!(player_turn, :player_actions, fun)
  end

  # *** *******************************
  # *** PRIVATE

  # TODO move the bulk of this out to the AI module
  defp if_ai_calc_commands(player_turn) do
    if player_turn.player_type == :ai do
      #player_turn = Map.put(player_turn, :maneuver_foresight, 4)
      pending_unit_ids =
        player_turn.player_actions
        |> ActionSelection.pending_player_unit_ids
      unit_maneuvers = Enum.map(pending_unit_ids, fn unit_id ->
        position =
          player_turn.cmd_squares
          |> Stream.filter(fn %GridSquare{unit_id: id} -> id == unit_id end)
          |> Enum.random
          |> GridSquare.position
        UnitAction.move_to(unit_id, position)
      end)
      Map.update!(player_turn, :player_actions, &ActionSelection.put(&1, unit_maneuvers))
    else
      player_turn
    end
  end

  defp cmd_squares(units, player_id, grid, islands) do
    units
    |> Unit.Enum.active_player_units(player_id)
    |> Enum.flat_map(&ManeuverPlanning.get_cmd_squares(&1, grid, islands, 1))
  end

  defp put_maneuver_squares(player_turn, squares) do
    %__MODULE__{player_turn | cmd_squares: squares}
  end

  defp maneuver_trapped_units(%__MODULE__{
    cmd_squares: cmd_squares,
    player_actions: player_actions
  } = player_turn) do
    unit_ids_that_have_cmd_squares = MapSet.new(cmd_squares, & &1.unit_id)
    trapped_unit_id? = fn id when is_integer(id) ->
      !MapSet.member?(unit_ids_that_have_cmd_squares, id)
    end
    unit_actions =
      player_actions
      |> ActionSelection.pending_player_unit_ids
      |> Stream.filter(trapped_unit_id?)
      |> Enum.map(&UnitAction.exit_or_run_aground/1)
    Map.update!(player_turn, :player_actions, &ActionSelection.put(&1, unit_actions))
  end

  defp determine_show_end_turn_btn(%__MODULE__{} = player_turn) do
    show? = player_turn.player_actions |> ActionSelection.turn_complete?
    %__MODULE__{player_turn | show_end_turn_btn?: show?}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(player, opts) do
      summary = %{
        player_actions: player.player_actions,
      }
     concat ["#Player-#{player.player_id}<", to_doc(summary, opts), ">"]
    end
  end
end
