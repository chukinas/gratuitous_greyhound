defmodule StatechartEventTest do

  use ExUnit.Case
  alias Statechart
  alias Statechart.Machine
  alias Statechart.CounterTest.Counter
  alias Statechart.CounterTest.CounterIncrement
  alias Statechart.CounterTest.CounterDecrement
  alias Statechart.CounterTest.CounterMachine

  def assert_count(machine, count) do
    assert %Counter{count: ^count} = Machine.get_context(machine)
    machine
  end

  test "ContextMachine" do
    CounterMachine.new()
    |> Statechart.transition(CounterIncrement.new())
    |> Statechart.transition(CounterIncrement.new())
    |> assert_count(2)
    |> Statechart.transition(CounterDecrement.new())
    |> Statechart.transition(CounterDecrement.new())
    |> Statechart.transition(CounterDecrement.new())
    |> Statechart.transition(CounterDecrement.new())
    |> assert_count(0)
  end

end
