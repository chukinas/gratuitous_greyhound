defmodule Chukinas.Sessions.RoomBackup do

  use Agent
  alias Chukinas.Sessions.Room

  def start_link(_init_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec put(Room.t) :: :ok
  def put(%Room{name: room_name} = room) do
    Agent.update(__MODULE__, &Map.put(&1, room_name, room))
  end

  @spec pop(String.t) :: Room.t | nil
  def pop(room_name) do
    Agent.get_and_update(__MODULE__, &Map.pop(&1, room_name))
  end

  def fetch_and_pop(room_name) do
    case pop(room_name) do
      nil -> :error
      room -> {:ok, room}
    end
  end

end
