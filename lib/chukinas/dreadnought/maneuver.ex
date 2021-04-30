alias Chukinas.Dreadnought.{ManeuverPartial, Maneuver, UnitAction, Unit}
alias Chukinas.Geometry.{Path, Position}
alias Chukinas.Util.ById

defmodule Maneuver do
  @moduledoc """
  Fully qualifies a unit's maneuvering for a given turn
  """

  # *** *******************************
  # *** TYPES

  @type t() :: [ManeuverPartial.t()]

  # *** *******************************
  # *** API

  def get_unit_with_tentative_maneuver(units, maneuver_action, turn_number) do
    unit = units |> ById.get!(maneuver_action.unit_id)
    case UnitAction.value(maneuver_action) do
      %Position{} = pos -> move_to(unit, pos)
      :exit_or_run_aground ->
        unit
        |> put_trapped_maneuver
        |> Unit.put_final_turn(turn_number + 1)
    end
  end

  def move_to(unit, pos) do
    path = Path.get_connecting_path(unit.pose, pos)
    Unit.put_path(unit, path)
  end

  # *** *******************************
  # *** PRIVATE

  defp put_trapped_maneuver(%Unit{
    compound_path: [path_partial],
    pose: pose1
  } = unit) do
    %ManeuverPartial{geo_path: last_round_path} = path_partial
    geo_path1 =
      last_round_path
      |> Path.put_pose(pose1)
    manuever = [
      ManeuverPartial.new(geo_path1, fadeout: true),
    ]
    unit |> Unit.put_compound_path(manuever)
  end
end
