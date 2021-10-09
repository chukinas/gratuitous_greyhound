defmodule SunsCore.DemoHappyPathTest do

  use ExUnit.Case
  import SunsCore.TestSupport.Helpers
  alias SunsCore.TestSupport.Setup
  alias SunsCore.TestSupport.CommandPhase
  alias SunsCore.TestSupport.JumpPhase

  test "Setup" do
    Setup.new_mission()
    |> Setup.confirm_players      |> assert_state(:adding_players)
    |> Setup.add_player           |> assert_state(:adding_players)
    |> Setup.confirm_players      |> assert_state(:setting_scale)
    |> Setup.set_scale            |> assert_state(:adding_tables) |> assert_snapshot(:scale, 2)
    |> Setup.add_table            |> assert_state(:adding_tables)
    |> Setup.add_table            |> assert_state(:adding_objectives)
    |> Setup.add_first_facility   |> assert_state(:adding_objectives)
    |> Setup.add_second_facility  |> assert_state(:playing)
  end

  test "Command Phase" do
    Setup.setup()
    |> refute_state(:setup) |> assert_state(:playing)
    |> assert_state(:command_phase)
    |> assert_state(:assigning_cmd)
    |> assert_turn_number(1)
    |> CommandPhase.assign_cmd
    |> assert_turn_number(1)
    |> assert_state(:determining_initiative)
    |> CommandPhase.roll_off_for_initiative
    |> assert_state(:jump_phase)
  end

  test "Jump Phase" do
    Setup.setup()
    |> CommandPhase.command_phase        |> assert_state(:jump_phase) |> assert_state(:main)
    |> JumpPhase.deploy_jump_point(1)    |> assert_state(:jump_phase) |> assert_state(:main)
    |> JumpPhase.deploy_jump_point(2)    |> assert_state(:jump_phase) |> assert_state(:main)
    |> JumpPhase.requisition_battlegroup |> assert_state(:deploying_battlegroup)
    |> JumpPhase.deploy_battlegroup      |> assert_state(:tactical_phase)
  end

end
