defmodule Statechart.MachineTest do

  use ExUnit.Case
  alias Statechart.Machine
  import Statechart, only: [transition: 2]

  # *** *******************************
  # *** TESTS

  test "Toggle" do
    Statechart.TestSupport.Toggle.Machine.new()
    |> assert_state(:off)
    |> transition(:flip) |> assert_state(:on)
    |> transition(:off)  |> assert_state(:off)
    |> transition(:off)  |> assert_state(:off)
  end

  test "Baseball" do
    throw_strike = &transition(&1, Statechart.TestSupport.Baseball.ThrowStrike.new())
    Statechart.TestSupport.Baseball.Batting.new()
    |> throw_strike.() |> assert_state(:at_bat)
    |> throw_strike.() |> assert_state(:at_bat)
    |> throw_strike.() |> assert_state(:struck_out)
  end

  test "Nested State" do
    Statechart.TestSupport.NestedState.Machine.new()
    |> Statechart.Helpers.render
    |> assert_state(:green)
    |> transition(:cycle)
    |> assert_state(:yellow)
  end

  test "Counter" do
    alias Statechart.TestSupport.Counter
    assert_count =
      fn machine, count ->
        assert %Counter.Context{count: ^count} = Machine.context(machine)
        machine
      end
    Counter.Machine.new()
    |> Counter.incr()
    |> Counter.incr()
    |> assert_count.(2)
    |> Counter.decr()
    |> Counter.decr()
    |> Counter.decr()
    |> Counter.decr()
    |> assert_count.(0)
  end

  test "Decisions" do
    Statechart.TestSupport.Decision.Machine.new()
    |> assert_state(:starting)
  end

  alias Statechart.TestSupport.PartialMachine.Driving

  test "Build a partial machine" do
    Statechart.TestSupport.PartialMachine.new()
    |> transition(Driving)
    |> assert_state(:new_york)
    |> transition(:fly_on_rocket_ship)
    |> assert_state(:mars)
  end

  test "Replay a partial into another machine" do
    Statechart.TestSupport.PartialAggregatorMachine.new()
    |> transition(:go_home)
    |> assert_state(:philly)
    |> transition(Driving)
    |> assert_state(:new_york)
    |> transition(:fly_on_rocket_ship)
    |> assert_state(:mars)
  end

  # *** *******************************
  # *** HELPERS

  def assert_state(machine, state_name) do
    assert Machine.in?(machine, state_name)
    machine
  end

  def refute_state(machine, state_name) do
    refute Machine.in?(machine, state_name)
    machine
  end

  def assert_root_state(machine) do
    assert Machine.at_root(machine)
    machine
  end

  def print_spec(machine) do
    Machine.get_spec(machine).()
    |> IOP.inspect
    machine
  end

end
