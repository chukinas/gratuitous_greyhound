defmodule Statechart.Helpers do

  alias Statechart.Machine
  require ExUnit.Assertions
  import ExUnit.Assertions

  def assert_state(machine, state_name) do
    assert Machine.in?(machine, state_name)
    machine
  end

  def refute_state(machine, state_name) do
    refute Machine.in?(machine, state_name)
    machine
  end

  def print_machine_and_spec(machine, msg \\ __MODULE__) do
    IOP.inspect %{
      machine: machine,
      spec: Machine.spec(machine)
    }, msg
    machine
  end

  def print_spec(machine, msg \\ __MODULE__) do
    IOP.inspect Machine.spec(machine), msg
    machine
  end

  def print_context(machine, msg \\ __MODULE__) do
    IOP.inspect Machine.context(machine), msg
    machine
  end

end
