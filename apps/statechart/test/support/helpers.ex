defmodule Statechart.TestSupport.Helpers do

  import ExUnit.Assertions, only: [assert: 1]
  alias Statechart.Machine

  def assert_state(machine, state) do
    assert Machine.in?(machine, state)
    machine
  end

end
