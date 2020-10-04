defmodule Chukinas.Insider.Boundary.Room do
  use GenServer
  alias Chukinas.Insider.Core.{Event, State, StateMachine}
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

  @impl GenServer
  def init(room_name) do
    {:ok, State.new(room_name)}
  end

  @impl GenServer
  def handle_call({:handle_event, event, user}, {pid, _tag}, state) do
    Process.monitor(pid)
    state = StateMachine.handle_event(event, user, state)
    {:reply, state, state}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, object, _reason}, state) do
    event = Event.new(:unregister_pid, object)
    state = StateMachine.handle_event(event, state)
    {:noreply, state, {:continue, :notify}}
  end
end
