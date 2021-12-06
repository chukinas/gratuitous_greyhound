defmodule SunsCore.TestSupport.JumpPhase do

  import SunsCore.Space
  alias SunsCore.Event.JumpPhase, as: JumpPhaseEvent
  alias SunsCore.Space.TablePose
  alias SunsCore.TestSupport.Helpers

  def jump_phase(machine) do
    machine
    |> deploy_jump_point(1)
    |> deploy_jump_point(2)
    |> requisition_battlegroup
    |> deploy_battlegroup
  end

  def deploy_jump_point(machine, table_id) do
    JumpPhaseEvent.DeployJumpPoint.new(1, TablePose.new(table_id, 20, 20))
    |> Helpers.apply_transition(machine)
  end

  def requisition_battlegroup(machine) do
    JumpPhaseEvent.RequisitionBattlegroup.new(1, :fighter_wing, 1)
    |> Helpers.apply_transition(machine)
  end

  def deploy_battlegroup(machine) do
    JumpPhaseEvent.DeployBattlegroup.new(1, new_pose(24, 24, 180 + 45))
    |> Helpers.apply_transition(machine)
  end

end
