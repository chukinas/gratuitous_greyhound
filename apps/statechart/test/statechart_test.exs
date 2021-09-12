defmodule Statechart.StateTest do

  use ExUnit.Case
  import Statechart.TestSupport.Helpers

  test "Machine" do
    defmodule StatechartTest.ToggleMachine do
      use Statechart, :machine
      on(:off, do: :off)
      default_state :off
      state :off do
        on(:flip, do: :on)
      end
      state :on do
        on(:flip, do: :off)
      end
    end

    StatechartTest.ToggleMachine.new()
    |> assert_state(:off)
    |> Statechart.transition(:flip)
    |> assert_state(:on)
    |> Statechart.transition(:off)
    |> assert_state(:off)
    |> Statechart.transition(:off)
    |> assert_state(:off)
  end

end
