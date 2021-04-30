alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, UnitAction, PlayerActions, ManeuverPlanning}
alias Chukinas.Geometry.GridSquare
alias Chukinas.Util.ById

defmodule ArtificialIntelligence do
  @moduledoc """
  Capable of navigating a ship around without crashing
  """

  # *** *******************************
  # *** MANEUVER EXECUTION

  # TODO none of these funcs are currently being used
  def calc_commands(%PlayerActions{player_active_unit_ids: unit_ids} = player_actions, units, grid, islands) do
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
      # TODO I don't like how this calculation is done here and in player turn
      # Should probably be centralized in Mission
      [] -> UnitAction.exit_or_run_aground(unit_id)
      [%GridSquare{} = square] -> UnitAction.move_to(unit_id, GridSquare.position(square))
    end
  end
end
