defmodule SunsCore.SetupTest do

  use ExUnit.Case
  import Statechart.Helpers
  import SunsCore.TestSupport.Helpers
  import SunsCore.TestSupport.Setup

  test "Game Setup, Happy Path" do
    new_mission()
    |> confirm_players |> assert_state(:adding_players)
    |> add_player |> assert_state(:adding_players)
    |> confirm_players |> assert_state(:setting_scale)
    |> set_scale |> assert_state(:adding_tables) |> assert_snapshot(:scale, 2)
    |> add_table |> assert_state(:adding_tables)
    |> add_table |> assert_state(:adding_objectives)
    |> add_first_facility |> assert_state(:adding_objectives)
    |> add_second_facility
    |> assert_state(:playing)
  end

end
