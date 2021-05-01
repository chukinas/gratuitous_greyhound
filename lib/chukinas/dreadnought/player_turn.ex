alias Chukinas.Dreadnought.{PlayerTurn, Unit, PlayerActions, ManeuverPlanning, UnitAction}
alias Chukinas.Geometry.{Size, Grid, GridSquare}

# TODO better name => Chukinas.Dreadnought.PlayerTurn ?
# TODO this name should match that of the Dyn World comp. Change this one or both to match
defmodule PlayerTurn do
  @moduledoc """
  Holds the information needed to a single player taking his turn

  It is regenerated for each new turn.
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # These never change throughout the mission
    field :id, atom(), default: :dynamic_world
    # TODO needed?
    field :player_id, integer()
    # TODO be more specific
    field :player_type, any()
    field :maneuver_foresight, integer(), default: 1
    field :margin, Size.t()
    field :grid, Grid.t()
    # These are handled locally by the dynamic component:
    field :player_actions, PlayerActions.t()
    # These must be set by the mission each turn:
    field :turn_number, integer()
    field :units, [Unit.t()], default: []
    field :cmd_squares, [GridSquare.t()], default: []
    field :show_end_turn_btn?, boolean(), default: false
  end

  # *** *******************************
  # *** NEW

  def new(player_id, player_type,  %{
    turn_number: turn_number,
    units: units,
    grid: grid,
    islands: islands,
    margin: margin
  }) do
    %__MODULE__{
      turn_number: turn_number,
      units: units,
      player_actions: PlayerActions.new(units, player_id),
      margin: margin,
      grid: grid,
      player_id: player_id,
      player_type: player_type
    }
    |> calc_cmd_squares(islands)
    |> maneuver_trapped_units
    |> if_ai_calc_commands
    |> determine_show_end_turn_btn
    # TODO make us of this terminology elsewhere
    # 'trapped' means the unit would normally be allowed to receive a move-to action,
    # but in this case it's jammed up against the side of the board or an island and will
    # leave the game next turn
  end

  def map(player_id, player_type, mission) do
    Map.from_struct(new(player_id, player_type, mission))
  end

  # *** *******************************
  # *** API

  # *** *******************************
  # *** PRIVATE

  # TODO move the bulk of this out to the AI module
  defp if_ai_calc_commands(token) do
    if token.player_type == :ai do
      pending_unit_ids =
        token.player_actions
        |> PlayerActions.pending_player_unit_ids
      unit_maneuvers = Enum.map(pending_unit_ids, fn unit_id ->
        position =
          token.cmd_squares
          |> Stream.filter(fn %GridSquare{unit_id: id} -> id == unit_id end)
          |> Enum.random
          |> GridSquare.position
        UnitAction.move_to(unit_id, position)
      end)
      Map.update!(token, :player_actions, &PlayerActions.put(&1, unit_maneuvers))
    else
      token
    end
  end

  defp calc_cmd_squares(token, islands) do
    squares = Enum.flat_map(token.units, fn unit ->
      if (unit.active?) and (unit.player_id == token.player_id) do
        ManeuverPlanning.get_cmd_squares(unit, token.grid, islands, token.maneuver_foresight)
      else
        []
      end
    end)
    %__MODULE__{token | cmd_squares: squares}
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
      |> PlayerActions.pending_player_unit_ids
      |> Stream.filter(trapped_unit_id?)
      |> Enum.map(&UnitAction.exit_or_run_aground/1)
    Map.update!(player_turn, :player_actions, &PlayerActions.put(&1, unit_actions))
  end

  defp determine_show_end_turn_btn(%__MODULE__{} = player_turn) do
    show? = player_turn.player_actions |> PlayerActions.turn_complete?
    %__MODULE__{player_turn | show_end_turn_btn?: show?}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(player, opts) do
      summary = %{
        player_actions: player.player_actions,
        units: player.units
      }
     concat ["#Player<", to_doc(summary, opts), ">"]
    end
  end
end
