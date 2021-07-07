defmodule Chukinas.Sessions.RoomServer do

  alias Chukinas.Sessions.Players
  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.RoomBackup
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
    room = case RoomBackup.fetch_and_pop(room_name) do
      {:ok, room} -> room
      :error -> Room.new(room_name)
    end
    ok(room)
  end

  def handle_call({:add_player, %{
    player_name: player_name,
    player_uuid: player_uuid,
  }}, _from, room) do
    {:ok, room} = Room.add_player(room, player_uuid, player_name)
    reply(room, :ok)
  end

  def handle_call({:drop_player, player_uuid}, _from, room) do
    IOP.inspect(player_uuid, "RoomServer handle_call drop_player")
    Players.send_room(player_uuid, nil)
    {result, room} = Room.drop_player(room, player_uuid)
    if result == :empty, do: Process.exit(self(), :normal)
    reply(room)
  end

  def handle_call(:get, _from, room) do
    {:reply, room, room}
  end

  def handle_cast({:toggle_ready, player_id}, room) do
    {:ok, room} = Room.toggle_ready(room, player_id)
    noreply(room)
  end

  def handle_cast({:update_mission, func}, room) do
    {:ok, room} = Room.update_mission(room, func)
    noreply(room)
  end

  def handle_continue(:send_all_players, room) do
    IOP.inspect room, "RoomServer continue send all players"
    for uuid <- Room.player_uuids(room) do
      Players.send_room(uuid, room)
    end
    {:noreply, room}
  end

  def terminate(:normal, _room) do
    IO.puts "closing a room!"
  end

  def terminate(reason, room) do
    IOP.inspect {reason, room}, "Room Server terminate args"
    RoomBackup.put(room)
  end

  # *** *******************************
  # *** RETURN TUPLES

  defp ok(room), do: {:ok, room, send_all()}

  defp noreply(room), do: {:noreply, room, send_all()}

  defp reply(room), do: {:reply, room, room, send_all()}

  defp reply(room, return_value), do: {:reply, return_value, room, send_all()}

  defp send_all, do: {:continue, :send_all_players}

end
