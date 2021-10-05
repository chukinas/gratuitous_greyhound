defmodule SunsCore.Event.PlayTest do

  use ExUnit.Case
  use Spatial, :pos
  import SunsCore.EventTestHelpers
  alias SunsCore.Event.JumpPhase.DeployJumpPoint
  alias SunsCore.Event.JumpPhase.RequisitionBattlegroup
  alias SunsCore.Event.JumpPhase.DeployBattlegroup
  alias SunsCore.Mission
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.Snapshot
  alias SunsCore.Space.TablePosition

  defp setup_deploy_jump_point do
    player_id = 1
    jump_point_location = TablePosition.new(1, 20, 20)
    [
      DeployJumpPoint.new(player_id, jump_point_location)
    ]
    ++ set_up_event_phase()
    ++ set_up_setup()
  end

  test "SunsCore.Event.JumpPhase.DeployJumpPoint" do
    snapshot =
      one_off_snapshot(setup_deploy_jump_point())
    assert 2 = snapshot |> Snapshot.helm_by_id(1) |> Helm.jump_cmd
    assert 1 = snapshot |> Snapshot.jump_points |> Enum.count
  end

  defp setup_requisition do
    requisition = RequisitionBattlegroup.new(1, :fighter_wing, 1)
    [requisition | setup_deploy_jump_point()]
  end

  test "SunsCore.Event.JumpPhase.RequisitionBattlegroup" do
    snapshot = one_off_snapshot(setup_requisition())
    assert -2 = snapshot |> Snapshot.helm_by_id(1) |> Helm.credits
  end

  defp setup_deploy_battlegroup do
    [
      DeployBattlegroup.new(1, [pose_new(21, 21, 45)]) |
      setup_requisition()
    ]
  end

  test "SunsCore.Event.JumpPhase.DeployBattlegroup" do
    snapshot = one_off_snapshot(setup_deploy_battlegroup())
    assert 1 =
      snapshot
      |> Snapshot.ships_by_table_id(1)
      |> Enum.count
  end

  defp set_up_event_phase, do: []
  defp set_up_setup, do: [
    add_table()
  ]

  defp one_off_snapshot(events) when is_list(events) do
    events
    |> Enum.reverse
    |> Enum.reduce(Mission.new(), &Mission.add_event(&2, &1))
    |> Mission.snapshot
  end

end
