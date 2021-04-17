alias Chukinas.Dreadnought.{Mission.Player, Unit, Commands}
alias Chukinas.Geometry.{Size, Grid}

# TODO better name => Chukinas.Dreadnought.PlayerTurn ?
# TODO this name should match that of the Dyn World comp. Change this one or both to match
defmodule Player do
  @moduledoc """
  Holds the information needed to a single player taking his turn
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    # These never change throughout the mission
    field :id, atom(), default: :dynamic_world
    # TODO needed?
    field :player_id, integer(), enforce: true
    field :margin, Size.t(), enforce: true
    field :grid, Grid.t(), enforce: true
    # These are handled locally by the dynamic component:
    field :commands, Commands.t(), enforce: true
    # These must be set by the mission each turn:
    field :turn_number, enforce: true
    field :units, [Unit.t()], default: [], enforce: true
  end

  # *** *******************************
  # *** NEW

  def new(player_id, %{
    units: units,
    grid: grid,
    islands: islands,
    margin: margin
  }) do
    %__MODULE__{
      units: calc_cmd_squares(units, player_id, grid, islands),
      commands: Commands.new(units, player_id),
      margin: margin,
      grid: grid,
      player_id: player_id
    }
  end

  def map(player_id, mission), do: Map.from_struct(new(player_id, mission))

  # *** *******************************
  # *** API

  # *** *******************************
  # *** PRIVATE

  defp calc_cmd_squares(units, player_id, grid, islands) do
    Enum.map(units, fn unit ->
      if unit.player_id == player_id do
        Unit.calc_cmd_squares(unit, grid, islands)
      else
        unit
      end
    end)
  end


  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(player, opts) do
      summary = %{
        active_unit_ids: player.active_unit_ids,
        commands: player.commands,
        units: player.units
      }
     concat ["#Player<", to_doc(summary, opts), ">"]
    end
  end
end
