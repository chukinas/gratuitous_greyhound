defmodule ClientCounter do
  use GenServer

  # *** *******************************
  # *** API

  def start_link() do
    state = %{count: 0, client_pids: MapSet.new()}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def inc() do
    GenServer.call(__MODULE__, :inc)
  end

  # *** *******************************
  # *** CALLBACKS

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call(:inc, from, state) do
    count = state.count + 1
    {calling_pid, _tag} = from
    calling_pids = MapSet.put(state.client_pids, calling_pid)
    state = %{count: count, client_pids: calling_pids}
    {:reply, state, state}
  end

end
