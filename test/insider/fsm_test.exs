defmodule Chukinas.Insider.FSMTest do
  use ExUnit.Case
  alias Chukinas.Insider.FSM


  test "insider state transitions" do
    assert {:ok, _} = FSM.start_link()
    assert {:introduction, _} = FSM.start_game()
    assert {:play, _} = FSM.end_intro()
    assert {:}
  end
end
