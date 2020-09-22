defmodule Chukinas.Insider.Server do
  use GenServer
  alias Chukinas.Insider.FSM

  # *** *******************************
  # *** API

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, room_name, [])
  end

  # *** *******************************
  # *** CALLBACKS

  def init(room_name) do
    state = %{name: room_name, fsm_state: :off, count: 0}
    {:ok, state}
  end

  def handle_call({:handle_event, event}, _from, state) do
    {reply, state} = FSM.handle_event(event, state)
    {:reply, reply, state}
  end
end
