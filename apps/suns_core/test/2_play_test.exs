defmodule SunsCore.PlayTest do

  use ExUnit.Case
  #import SunsCore.TestSupport.Helpers
  alias SunsCore.TestSupport.Setup
  alias SunsCore.TestSupport.Helpers
  import Statechart.Helpers

  test "Game Play" do
    Setup.setup()
    |> refute_state(:setup)
    |> assert_state(:playing)
    |> assert_state(:command_phase)
    |> Helpers.assert_turn_number(1)
  end

end
