alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, Command, ActionSelection, ById, PotentialPath}

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

  defp get_command(%Unit{id: unit_id} = unit, grid, islands) do
    rand_cmd_square =
      unit
      |> PotentialPath.get_stream(grid, islands, 1)
      |> print_count
      |> Enum.take(1)
    case rand_cmd_square do
      [] -> Command.exit_or_run_aground(unit_id)
      [%PotentialPath{} = pot_path] -> Command.move_to(unit_id, PotentialPath.position(pot_path))
    end
  end

  #defp get_straightest_cmd(potential_paths, current_pose) do
  #  potential_paths
  #  |> Stream.map(&PotentialPath.position/1)
  #  |> Stream.dedup
  #end

  defp print_count(paths) do
    IOP.inspect Enum.count(paths), "path count"
    paths
  end
end
