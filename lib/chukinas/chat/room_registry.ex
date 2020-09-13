defmodule Chukinas.Chat.Room.Registry do
  use GenServer
  alias Chukinas.Chat.Room

  #############################################################################
  # TYPES
  #############################################################################

  @type room_name :: String.t
  @type room_pid :: pid
  # I use this instead of just the pid to make it easier to handle :DOWN events
  @type room_record :: {room_name, room_pid}
  @type registry_state :: %{optional(room_name) => room_record}

  #############################################################################
  # CLIENT API
  #############################################################################

  def start_link(_init_arg) do
    state = Map.new()
    GenServer.start_link(__MODULE__, state,  name: __MODULE__)
  end

  @spec get_room(room_name) :: room_pid
  def get_room(room_name) do
    GenServer.call(__MODULE__, {:get_room, room_name})
  end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:get_room, room_name}, _from, state) do
    {room_record, state} = case Map.get(state, room_name) do
      nil ->
        room_record = create_room(room_name)
        new_state = Map.put(state, room_name, room_record)
        {room_record, new_state}
      room_record -> {room_record, state}
    end
    {_room_name, room_pid} = room_record
    {:reply, room_pid, state}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, object, _reason}, state) do
    {room_name, _room_pid} =
      state
      |> Map.values()
      |> Enum.find(fn {room_name, _room_pid} -> room_name == object end)
    new_state = Map.delete(state, room_name)
    {:noreply, new_state}
  end

  #############################################################################
  # HELPERS
  #############################################################################

  @spec create_room(room_name) :: room_record
  def create_room(room_name) do
    child_spec = Room.child_spec(room_name)
    {:ok, pid} = DynamicSupervisor.start_child(Room.Supervisor, child_spec)
    Process.monitor(pid)
    {room_name, pid}
  end

end
