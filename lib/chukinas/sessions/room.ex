alias Chukinas.Sessions.Room
alias Chukinas.Sessions.RoomRegistry

defmodule Room do
  use GenServer

  # *** *******************************
  # *** CLIENT

  def child_spec(room_name) do
    %{
      id: room_name,
      start: {__MODULE__, :start_link, [room_name]}
    }
  end

  def start_link(room_name) do
    GenServer.start_link(
      __MODULE__,
      room_name,
      name: RoomRegistry.build_name(room_name)
    )
  end

  def add_member(room, member_name) do
    room
    |> get_room
    |> GenServer.call({:add_member, member_name})
  end

  def print_members(room) do
    room
    |> get_room
    |> GenServer.cast(:print_members)
  end

  defp get_room(room) when is_pid(room), do: room

  defp get_room(room_name) when is_binary(room_name) do
    RoomRegistry.build_name(room_name)
  end

  # *** *******************************
  # *** Callbacks

  def init(room_name) when is_binary(room_name) do
    {:ok, Room.Impl.new(room_name)}
  end

  def handle_call({:add_member, member_name}, _from, room) do
    {:ok, member_number, room} = Room.Impl.add_member(room, member_name)
    {:reply, {:member_number, member_number}, room}
  end

  def handle_cast(:print_members, room) do
    Room.Impl.print_members(room)
    {:noreply, room}
  end

end
