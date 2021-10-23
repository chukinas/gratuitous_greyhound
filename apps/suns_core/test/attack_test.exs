defmodule SunsCore.AttackTest do

  use ExUnit.Case
  alias SunsCore.Mission.Attack
  alias SunsCore.Mission.Battlegroup
  alias SunsCore.Mission.BattlegroupAndShips
  alias SunsCore.Mission.Object
  alias SunsCore.Space.TablePose

  test "Attack" do
    {bg, ships} = _attackers =
      Battlegroup.new_bg_and_ships(
        :bomber_wing,
        [TablePose.new(1, 0, 0, 45)],
        1,
        1,
        1
      )
    attack =
      Attack.new(
        BattlegroupAndShips.new(bg, ships),
        Object.new_facility(2, table_pose: TablePose.new(1, 6, 6)),
        :primary,
        1
      )
    assert Attack.target_has_silhouette?(attack)
    assert Attack.in_range_and_fire_arc?(attack)
  end

end
