defmodule SunsCore.TestSupport.Helpers do

  import ExUnit.Assertions, only: [assert: 1, refute: 1]
  alias SunsCore.Machine, as: SunsCoreMachine
  alias Statechart.Machine
  alias SunsCore.Context

  def assert_state(machine, state_name) do
    assert Machine.in?(machine, state_name)
    machine
  end

  def refute_state(machine, state_name) do
    refute Machine.in?(machine, state_name)
    machine
  end

  def assert_snapshot(machine, key, expected_value) do
    assert ^expected_value = SunsCoreMachine.snapshot(machine, key)
    machine
  end

  def assert_turn_number(machine, turn_number) do
    assert turn_number ==
      machine
      |> Machine.context
      |> Context.turn_number
    machine
  end

  def apply_transition(event, machine), do: Machine.transition(machine, event)

  def print_spec(machine) do
    Machine.get_spec(machine).()
    |> IOP.inspect
    machine
  end

end
