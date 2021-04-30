alias Chukinas.Dreadnought.{PlayerTurn, Unit, PlayerActions, ManeuverPlanning}
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

  def new(player_id, %{
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
      player_id: player_id
    }
    |> calc_cmd_squares(islands)
    |> resolve_exiting_units
    |> determine_show_end_turn_btn
  end

  def map(player_id, mission), do: Map.from_struct(new(player_id, mission))

  # *** *******************************
  # *** API

  # *** *******************************
  # *** PRIVATE

  defp calc_cmd_squares(token, islands) do
    squares = Enum.flat_map(token.units, fn unit ->
      if (unit.active?) and (unit.player_id == token.player_id) do
        ManeuverPlanning.get_cmd_squares(unit, token.grid, islands)
      else
        []
      end
    end)
    %__MODULE__{token | cmd_squares: squares}
  end

  defp resolve_exiting_units(%__MODULE__{
    cmd_squares: cmd_squares,
    units: units,
    player_id: player_id,
    player_actions: player_actions
  } = player_turn) do
    unit_ids_that_have_cmd_squares = MapSet.new(cmd_squares, & &1.unit_id)
    IOP.inspect unit_ids_that_have_cmd_squares, "unit ids w sq"
    unit_has_no_cmd_squares? = fn id ->
      IOP.inspect id
      not MapSet.member?(unit_ids_that_have_cmd_squares, id)
    end
    exiting_units =
      units
      |> Unit.Enum.active_player_unit_ids(player_id)
      |> Stream.filter(unit_has_no_cmd_squares?)
    player_actions = Enum.reduce(exiting_units, player_actions, fn unit, player_actions ->
      PlayerActions.exit_or_run_aground(player_actions, unit.id)
    end)
    %{player_turn | player_actions: player_actions}
  end

  defp determine_show_end_turn_btn(%__MODULE__{} = player_turn) do
    hide? =
      player_turn.player_actions
      |> PlayerActions.actions_available?
    %__MODULE__{player_turn | show_end_turn_btn?: !hide?}
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
