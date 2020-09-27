defmodule Chukinas.Insider.StateMachineTest do
  use ExUnit.Case
  alias Chukinas.Insider.StateMachine


  test "insider state transitions" do
    assert {:ok, _} = StateMachine.start_link()
    assert {:introduction, _} = StateMachine.start_game()
    assert {:play, _} = StateMachine.end_intro()
    assert {:}
  end
end
