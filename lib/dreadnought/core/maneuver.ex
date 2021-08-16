alias Dreadnought.Core.{Maneuver, UnitAction, Unit}
alias Dreadnought.Paths
alias Dreadnought.Util.IdList
alias Unit.Event, as: Ev

defmodule Maneuver do
  @moduledoc """
  Fully qualifies a unit's maneuvering for a given turn
  """

  use Dreadnought.PositionOrientationSize

  # *** *******************************
  # *** TYPES

  @type t() :: [Ev.Maneuver.t()]

  # *** *******************************
  # *** API

  def get_unit_with_tentative_maneuver(units, maneuver_action, turn_number) do
    unit = units |> IdList.fetch!(maneuver_action.unit_id)
    case UnitAction.value(maneuver_action) do
      position when has_position(position) -> move_to(unit, position)
        # TODO rename :trapped
      :exit_or_run_aground ->
        unit
        |> put_trapped_maneuver
        |> Unit.put(Ev.Destroyed.by_leaving_arena(turn_number))
    end
  end

  def move_to(unit, position) do
    path = Paths.get_connecting_path(pose_from_map(unit), position)
    maneuver = Ev.Maneuver.new(path)
    Unit.put(unit, maneuver)
  end

  # *** *******************************
  # *** PRIVATE

  defp put_trapped_maneuver(%Unit{} = unit) do
    events = [
      Ev.Maneuver.new(Paths.new_straight(unit, 300))
    ]
    Unit.put(unit, events)
  end
end
