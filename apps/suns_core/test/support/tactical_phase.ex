defmodule SunsCore.TestSupport.TacticalPhase do

  use SunsCore.Event.CommandPhase
  use SunsCore.Context.JumpPhase
  use SunsCore.Event.TacticalPhase
  import SunsCore.Space
  alias SunsCore.Event
  alias SunsCore.TestSupport.Helpers
  alias SunsCore.Mission.Order
  alias SunsCore.Mission.Ship.Move, as: ShipMove

  def tactical_phase(machine) do
    machine
    |> issue_engage_order
  end

  def issue_engage_order(machine) do
    Order.engage(1, objective: 1)
    |> IssueOrder.new
    |> Helpers.apply_transition(machine)
  end

  # TODO rename move_towards_station
  def move(machine) do
    ShipMove.new(1, new_position(22, 22))
    |> List.wrap
    |> Event.MovementStep.Move.new
    |> Helpers.apply_transition(machine)
  end

  def attack_engaged_target(machine) do
    AttackEngagedTarget.new()
    |> Helpers.apply_transition(machine)
  end

end
