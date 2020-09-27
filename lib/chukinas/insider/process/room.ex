defmodule Chukinas.Insider.Room do
  use GenServer
  alias Chukinas.Insider.{Event, State, StateMachine}

  # *** *******************************
  # *** API

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, room_name, [])
  end

  @spec handle_event(Event.t()) :: State.t()
  def handle_event(event) do
    event
    |> Event.get_room_pid()
    |> GenServer.call({:handle_event, event})
  end

  # *** *******************************
  # *** CALLBACKS

  def init(room_name) do
    {:ok, State.new(room_name)}
  end

  # @spec handle_call({:handle_event, Event.t()}, any(), State.t()) :: any()
  def handle_call({:handle_event, event}, _from, state) do
    state = StateMachine.handle_event(event, state)
    # {user, users} =
    #   event
    #   |> User.from_event()
    #   |> Users.set_id(state.users)
    # state =
    #   state
    #   |> Map.put(users: users)
    # # TODO put user back in event
    # state = case user.new? do
    #   true -> StateMachine.handle_event(event, state)
    # end
    # {reply, state} = StateMachine.handle_event(event, state)
    reply = state
    {:reply, reply, state}
  end
end
