defmodule Chukinas.Sessions.RoomServer do

  alias Chukinas.Sessions.Players
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

  def handle_call({:add_member, %{
    player_name: player_name,
    player_uuid: player_uuid,
  }}, _from, room) do
    {:ok, _member_number, room} = Room.add_player(room, player_uuid, player_name)
    {:reply, :ok, room, {:continue, :send_all_players}}
  end

  def handle_call({:remove_player, player_uuid}, _from, room) do
    # TODO kill room if now empty
    room = Room.remove_player(room, player_uuid)
    Players.send_room(player_uuid, nil)
    {:reply, room, room, {:continue, :send_all_players}}
    # TODO isn't there a way to have a function execute here?
  end

  def handle_call(:get, _from, room) do
    {:reply, room, room}
  end

  def handle_cast({:toggle_ready, player_id}, room) do
    {:noreply, Room.toggle_ready(room, player_id), {:continue, :send_all_players}}
  end

  def handle_continue(:send_all_players, room) do
    IOP.inspect room, "RoomServer continue send all players"
    for uuid <- Room.player_uuids(room) do
      Players.send_room(uuid, room)
    end
    {:noreply, room}
  end

  def terminate(reason, room) do
    IOP.inspect {reason, room}, "Room Server terminate args"
  end

end
