defmodule Chukinas.Sessions.RoomServer do

  alias Chukinas.Sessions.PlayerRegistry
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.RoomRegistry
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
    {:ok, member_number, room} = Room.add_player(room, member_uuid, member_name)
    send_room_to_players(room)
    {:reply, {:member_number, member_number}, room}
  end

  def handle_call({:remove_player, player_uuid}, _from, room) do
    # TODO kill room if now empty
    room = Room.remove_player(room, player_uuid)
    send_room_to_players room
    send_room_to_players nil, player_uuid
    {:reply, room, room}
    # TODO isn't there a way to have a function execute here?
  end

  def handle_call(:get, _from, room) do
    {:reply, room, room}
  end

  # *** *******************************
  # *** FUNCTIONS

  # TODO set timeout to kill room if inactive for __ mins

  defp send_room_to_players(room, recipients \\ :all)

  #defp send_room_to_players(room, recipients) when is_list(recipients) do
  #  Enum.each recipients, &send_room_to_players(room, &1)
  #end

  defp send_room_to_players(room, :all) do
    for uuid <- Room.player_uuids(room) do
      send_room_to_players(room, uuid)
    end
  end

  defp send_room_to_players(room, player_uuid) when is_binary(player_uuid) do
    IO.puts "RoomServer send room to #{player_uuid}"
    for pid <- PlayerRegistry.pids(player_uuid) do
      send pid, {:update_room, room}
    end
  end

end
