defmodule Chukinas.Chat.Room.Registry do
  use GenServer
  alias Chukinas.Chat.Room
  # alias Chukinas.Chat.Room.Supervisor, as: RoomSupervisor

  #############################################################################
  # TYPES
  #############################################################################

  @type room_name :: String.t
  @type room_pid :: pid
  @type registry_state :: %{optional(room_name) => room_pid}

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
    {room_pid, state} = case Map.get(state, room_name) do
      nil ->
        room_pid = create_room(room_name)
        new_state = Map.put(state, room_name, room_pid)
        {room_pid, new_state}
      pid -> {pid, state}
    end
    {:reply, room_pid, state}
  end

  @impl GenServer
  def handle_info({:DOWN, _ref, :process, object, _reason}, state) do
    downed_room_record =
      state
      |> Map.values()
      |> Enum.find(fn r -> r.pid == object end)
    new_state = Map.delete(state, downed_room_record.name)
    {:noreply, new_state}
  end

  #############################################################################
  # HELPERS
  #############################################################################

  @spec create_room(room_name) :: room_pid
  def create_room(room_name) do
    # {:ok, pid} = RoomSupervisor.start_room(room_name)
    {:ok, pid} = GenServer.start_link(Room, room_name)
    Process.monitor(pid)
    pid
  end

end
