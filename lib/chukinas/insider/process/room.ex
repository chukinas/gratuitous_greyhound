defmodule Chukinas.Insider.Room do
  use GenServer
  alias Chukinas.Insider.{Event, State, StateMachine}
  alias Chukinas.User

  # *** *******************************
  # *** API

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, room_name, [])
  end

  @spec handle_event(Event.t(), User.t()) :: State.t()
  def handle_event(event, user) do
    room = Event.get_room_pid(event)
    GenServer.call(room, {:handle_event, event, user})
  end

  # *** *******************************
  # *** CALLBACKS

  def init(room_name) do
    {:ok, State.new(room_name)}
  end

  # @spec handle_call({:handle_event, Event.t()}, any(), State.t()) :: any()
  def handle_call({:handle_event, event, user}, _from, state) do
    state = StateMachine.handle_event(event, user, state)
    {:reply, state, state}
  end
end
