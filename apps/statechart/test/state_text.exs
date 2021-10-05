defmodule Statechart.StateTest do

  use ExUnit.Case
  alias Statechart
  alias Statechart.Type.NodeName

  test "State.recursive_stream/1" do
    beginning_state = [2, 1, %Root{}]
    streamed_states = [
      [2, 1],
      [1],
      NodeName.root()
    ]
    assert streamed_states == NodeName.recursive_stream(beginning_state) |> Enum.to_list()
  end

  test "State.recursive_stream/1 at root level" do
    beginning_state = NodeName.root()
    streamed_states = [
      %Root{}
    ]
    assert streamed_states == NodeName.recursive_stream(beginning_state) |> Enum.to_list()
  end

end
