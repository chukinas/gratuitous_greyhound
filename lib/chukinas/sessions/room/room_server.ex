alias Chukinas.Sessions.{RoomServer, RoomRegistry, Room}
alias Chukinas.Sessions.UserRegistry

defmodule RoomServer do
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

  # *** *******************************
  # *** CALLBACKS

  def init(room_name) when is_binary(room_name) do
    {:ok, Room.new(room_name)}
  end

  def handle_call({:add_member, member_uuid, member_name}, _from, room) do
    with {:ok, member_number, room} <- Room.add_player(room, member_uuid, member_name) do
      send_all(room)
      {:reply, {:member_number, member_number}, room}
    else
      _ -> {:reply, :error, room}
    end
  end

  def handle_call(:get, _from, room) do
    {:reply, room, room}
  end

  # *** *******************************
  # *** FUNCTIONS

  defp send_all(room) do
    for uuid <- Room.player_uuids(room) do
      for pid <- UserRegistry.pids(uuid) do
        send pid, {:update_room, room}
      end
    end
  end

end
