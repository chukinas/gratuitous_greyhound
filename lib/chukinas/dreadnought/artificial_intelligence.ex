alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, Command, ActionSelection, ById}

defmodule ArtificialIntelligence do
  @moduledoc """
  Capable of navigating a ship around without crashing
  """

  # *** *******************************
  # *** MANEUVER EXECUTION

  def calc_commands(%ActionSelection{my_unit_ids: unit_ids} = action_selection, units, grid, islands) do
    player_units = ById.get!(units, unit_ids)
    commands = Enum.map(player_units, &get_command(&1, grid, islands))
    ActionSelection.put_commands(action_selection, commands)
  end

  defp get_command(%Unit{} = unit, grid, islands) do
    cmd_square =
      Unit.get_cmd_squares(unit, grid, islands)
      |> Enum.random
      |> IOP.inspect("ai rand command")
    Command.move_to(unit.id, cmd_square.center)
  end
end
