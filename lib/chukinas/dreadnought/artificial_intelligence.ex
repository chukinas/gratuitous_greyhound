alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, UnitAction, PlayerActions, ById, ManeuverPlanning}
alias Chukinas.Geometry.GridSquare

defmodule ArtificialIntelligence do
  @moduledoc """
  Capable of navigating a ship around without crashing
  """

  # *** *******************************
  # *** MANEUVER EXECUTION

  def calc_commands(%PlayerActions{my_unit_ids: unit_ids} = player_actions, units, grid, islands) do
    player_units = ById.get!(units, unit_ids)
    commands = Enum.map(player_units, &get_command(&1, grid, islands))
    PlayerActions.put_commands(player_actions, commands)
  end

  defp get_command(%Unit{id: unit_id} = unit, grid, islands) do
    rand_cmd_square =
      unit
      |> ManeuverPlanning.get_cmd_squares(grid, islands, 2)
      |> Enum.take(1)
    case rand_cmd_square do
      [] -> UnitAction.exit_or_run_aground(unit_id)
      [%GridSquare{} = square] -> UnitAction.move_to(unit_id, GridSquare.position(square))
    end
  end
end
