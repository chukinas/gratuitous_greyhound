alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, Command, ActionSelection, ById}

defmodule ArtificialIntelligence do
  @moduledoc """
  Capable of navigating a ship around without crashing
  """

  # *** *******************************
  # *** MANEUVER EXECUTION

  def calc_commands(%ActionSelection{} = action_selection, units, grid, islands) do
    units
    |> ById.get!(action_selection.my_unit_ids)
    |> get_command(grid, islands)
  end

  defp get_command(unit, grid, islands) do
    cmd_square =
      Unit.get_cmd_squares(unit, grid, islands)
      |> Enum.random
    Command.move_to(unit.id, cmd_square.center)
  end
end
