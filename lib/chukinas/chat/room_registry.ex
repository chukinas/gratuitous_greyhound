defmodule Chukinas.Chat.Room.Registry.Record do
  defstruct [:name, :pid]
end

defmodule Chukinas.Chat.Room.Registry do
  use GenServer
  alias Chukinas.Chat.Room
  alias Chukinas.Chat.Room.Registry.Record
  # alias Chukinas.Chat.Room.Supervisor, as: RoomSupervisor

  #############################################################################
  # STATE
  #############################################################################

  # Map
  # key: room_name
  # value: Record

  #############################################################################
  # CLIENT API
  #############################################################################

  def start_link(_init_arg) do
    state = Map.new()
    GenServer.start_link(__MODULE__, state,  name: __MODULE__)
  end

  def get_room(room_name) do
    GenServer.call(__MODULE__, {:get_room, room_name})
  end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:get_room, room_name}, _from, state) do
    {%Record{} = room_record, state} = case Map.get(state, room_name) do
      %Record{} = record -> {record, state}
      nil -> create_room(room_name, state)
    end
    {:reply, room_record.pid, state}
  end

  @impl true
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

  def create_room(room_name, state) do
    # {:ok, pid} = RoomSupervisor.start_room(room_name)
    {:ok, pid} = GenServer.start_link(Room, room_name)
    Process.monitor(pid)
    new_record = %Record{name: room_name, pid: pid}
    new_state = Map.put(state, room_name, new_record)
    {new_record, new_state}
  end

end
