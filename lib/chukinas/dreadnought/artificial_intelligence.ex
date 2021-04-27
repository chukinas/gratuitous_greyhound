alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, UnitOrders, PlayerActions, ById, PotentialPath}

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
      |> PotentialPath.get_stream(grid, islands, 1)
      |> print_count
      |> Enum.take(1)
    case rand_cmd_square do
      [] -> UnitOrders.exit_or_run_aground(unit_id)
      [%PotentialPath{} = pot_path] -> UnitOrders.move_to(unit_id, PotentialPath.position(pot_path))
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
