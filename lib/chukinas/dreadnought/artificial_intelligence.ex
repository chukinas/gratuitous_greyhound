alias Chukinas.Dreadnought.{ArtificialIntelligence, Unit, Command, ActionSelection, ById, PotentialPath}

defmodule ArtificialIntelligence do
  @moduledoc """
  Capable of navigating a ship around without crashing
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :original_square, GridSquare.t()
    field :current_square, GridSquare.t()
    field :current_unit, Unit.t()
    field :current_depth, integer()
    field :target_depth, integer()
    field :get_squares, (Unit.t() -> [GridSquare.t()])
  end

  # *** *******************************
  # *** MANEUVER EXECUTION

  def calc_commands(%ActionSelection{my_unit_ids: unit_ids} = action_selection, units, grid, islands) do
    player_units = ById.get!(units, unit_ids)
    commands = Enum.map(player_units, &get_command(&1, grid, islands))
    ActionSelection.put_commands(action_selection, commands)
  end

  defp get_command(%Unit{} = unit, grid, islands) do
    position =
      unit
      |> PotentialPath.get_stream(grid, islands, 6)
      |> print_count
      |> Enum.take(1)
      |> List.first
      |> PotentialPath.position
    # TODO must handle for empty list
    Command.move_to(unit.id, position)
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
