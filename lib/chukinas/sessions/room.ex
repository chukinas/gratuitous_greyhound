alias Chukinas.Sessions.Room

defmodule Room do
  use GenServer

  @me __MODULE__

  # *** *******************************
  # *** CLIENT

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end

  def add_member(member_name) do
    GenServer.call(@me, {:add_member, member_name})
  end

  def print_members do
    GenServer.cast(@me, :print_members)
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
