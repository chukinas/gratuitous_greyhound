defmodule SunsCore.PlayTest do

  use ExUnit.Case
  #import SunsCore.TestSupport.Helpers
  alias SunsCore.TestSupport.CommandPhase
  alias SunsCore.TestSupport.Setup
  alias SunsCore.TestSupport.Helpers
  #
  # TODO roll into TestSupport.Helpers
  import Statechart.Helpers

  test "Command Phase" do
    Setup.setup()
    |> refute_state(:setup)
    |> assert_state(:playing) |> assert_state(:command_phase) |> assert_state(:assigning_cmd)
    |> Helpers.assert_turn_number(1)
    |> CommandPhase.assign_cmd
    |> Helpers.assert_turn_number(1)
    |> assert_state(:determining_initiative)
    |> CommandPhase.roll_off_for_initiative
    |> assert_state(:jump_phase)
  end

end
