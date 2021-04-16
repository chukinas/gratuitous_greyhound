alias Chukinas.Dreadnought.{Mission.Player, Command, Unit}

defmodule Player do
  @moduledoc """
  Holds the information needed to a single player taking his turn
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :active_units, [Unit.t()], default: []
    # TODO should this just be all units?
    # That way I don't have to keep concat'ing back and forth
    # Also, the template is always forced to concat the two.
    field :other_units, [Unit.t()], default: []
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
    %__MODULE__{ other_units: units }
    |> calc_active_units
  end

  # *** *******************************
  # *** API

  def start_turn_sequence(%{grid: grid, islands: islands} = mission) do
    units =
      mission.units
      |> Enum.map(& Unit.calc_cmd_squares &1, grid, islands)
    %{mission | units: units}
  end

  def issue_command(mission_player, command) do
    mission_player
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  def turn_complete?(mission_player), do: Enum.empty?(mission_player.active_units)

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
    {completed_units, incomplete_units} =
      player.active_units ++ player.other_units
      |> Enum.split_with(& &1.id in complete_unit_ids)
    {active_units, other_incomplete_units} =
      incomplete_units
      |> Enum.split(1)
    %{player |
      active_units: active_units,
      other_units: completed_units ++ other_incomplete_units
    }
    |> IOP.inspect("calc current unit")
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(player, opts) do
      summary = %{
        active_unit_ids: Enum.map(player.active_units, & &1.id),
        inactive_unit_ids: Enum.map(player.other_units, & &1.id)
        # TODO add commands
      }
     concat ["#Player<", to_doc(summary, opts), ">"]
    end
  end
end
