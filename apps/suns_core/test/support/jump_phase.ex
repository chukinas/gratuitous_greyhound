defmodule SunsCore.TestSupport.JumpPhase do

  use SunsCore.Event.CommandPhase
  use SunsCore.Event.JumpPhase
  import SunsCore.Space
  alias SunsCore.TestSupport.Helpers

  def jump_phase(machine) do
    machine
    |> deploy_jump_point(1)
    |> deploy_jump_point(2)
  end

  def deploy_jump_point(machine, table_id) do
    DeployJumpPoint.new(1, new_table_position(table_id, 20, 20))
    |> Helpers.apply_transition(machine)
  end

  def requisition_battlegroup(machine) do
    RequisitionBattlegroup.new(1, :fighter_wing, 1)
    |> Helpers.apply_transition(machine)
  end

  def deploy_battlegroup(machine) do
    DeployBattlegroup.new(1, new_pose(24, 24, 180 + 45))
    |> Helpers.apply_transition(machine)
  end

end
