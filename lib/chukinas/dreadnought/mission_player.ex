alias Chukinas.Dreadnought.{Mission.Player, Command, Unit, ById}

defmodule Player do
  @moduledoc """
  Holds the information needed to a single player taking his turn
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :active_unit_ids, [integer()], default: []
    field :units, [Unit.t()], default: []
    field :commands, [Command.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(%{
    units: units,
    grid: grid,
    islands: islands
  }) do
    units =
      units
      |> Enum.map(& calc_cmd_squares_if_mine(&1, grid, islands))
    %__MODULE__{units: units}
    |> calc_active_units
  end

  # *** *******************************
  # *** API

  def issue_command(mission_player, command) do
    mission_player
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  def turn_complete?(mission_player), do: Enum.empty?(mission_player.active_unit_ids)

  # *** *******************************
  # *** PRIVATE

  defp calc_cmd_squares_if_mine(unit, grid, islands) do
    # Currently, all ships are mine, but later they won't be.
    Unit.calc_cmd_squares(unit, grid, islands)
  end

  defp calc_active_units(player) do
    complete_unit_ids =
      player.commands
      |> Enum.map(& &1.unit_id)
    {_completed_units, incomplete_units} =
      player.units
      |> Enum.split_with(& &1.id in complete_unit_ids)
    {active_units, _other_incomplete_units} =
      incomplete_units
      |> Enum.split(1)
    %{player | active_unit_ids: ById.to_ids(active_units)}
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
