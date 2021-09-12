defmodule SunsCore.TestSupport.Helpers do

  import ExUnit.Assertions, only: [assert: 1]
  alias SunsCore.StateMachine
  alias Statechart.Machine
  alias SunsCore.Mission.Snapshot, as: Cxt

  def assert_snapshot(machine, key, expected_value) do
    assert ^expected_value = StateMachine.snapshot(machine, key)
    machine
  end

  def assert_turn_number(machine, turn_number) do
    assert turn_number ==
      machine
      |> Machine.context
      |> Cxt.turn_number
    machine
  end

  def apply_transition(event, machine), do: StateMachine.transition(machine, event)

end
