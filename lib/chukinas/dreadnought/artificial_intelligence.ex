alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, Command}

defmodule ArtificialIntelligence do
  @moduledoc """
  Capable of navigating a ship around without crashing
  """

  # *** *******************************
  # *** MANEUVER EXECUTION

  def get_command(unit, grid, islands) do
    cmd_square =
      Unit.get_cmd_squares(unit, grid, islands)
      |> Enum.random
    Command.move_to(unit.id, cmd_square.center)
  end
end
