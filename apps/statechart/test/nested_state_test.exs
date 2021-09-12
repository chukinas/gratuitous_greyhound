defmodule Statechart.NestedStateTest do

  use ExUnit.Case
  alias Statechart.Helpers
  alias Statechart.TestSupport.NestedState.Machine, as: NestedMachine

  test "Nested State" do
    NestedMachine.new()
    |> Helpers.assert_state(:green)
    |> NestedMachine.transition(:cycle)
    |> Helpers.assert_state(:yellow)
  end

end
