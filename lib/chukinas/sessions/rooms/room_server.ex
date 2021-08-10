# TODO move of rename directory?
defmodule Chukinas.Sessions.MissionServer do

  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Sessions.Players
  alias Chukinas.Sessions.MissionBackup
  alias Chukinas.Sessions.MissionRegistry
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
      name: MissionRegistry.build_name(room_name)
    )
  end

  # *** *******************************
  # *** CALLBACKS

  def init(room_name) when is_binary(room_name) do
    room = case MissionBackup.fetch_and_pop(room_name) do
      {:ok, room} -> room
      :error -> MissionBuilder.online(room_name)
    end
    ok(room)
  end

  def handle_call({:add_player, %{
    player_name: player_name,
    player_uuid: player_uuid,
  }}, _from, mission) do
    {:ok, mission} = MissionBuilder.add_player(mission, player_uuid, player_name)
    reply(mission, :ok)
  end

  def handle_call({:drop_player, player_uuid}, _from, mission) do
    IOP.inspect(player_uuid, "MissionServer handle_call drop_player")
    Players.send_room(player_uuid, nil)
    mission = Mission.drop_player_by_uuid(mission, player_uuid)
    if Mission.empty?(mission), do: Process.exit(self(), :normal)
    reply(mission)
  end

  def handle_call(:get, _from, room) do
    {:reply, room, room}
  end

  def handle_cast({:toggle_ready, player_id}, room) do
    {:ok, room} = Mission.toggle_ready(room, player_id)
    noreply(room)
  end

  # TODO deprecate
  def handle_cast({:update_mission, func}, mission) do
    func.(mission) |> noreply
  end

  def handle_continue(:send_all_players, mission) do
    IOP.inspect mission, "MissionServer continue send all players"
    for uuid <- Mission.player_uuids(mission) do
      Players.send_room(uuid, mission)
    end
    {:noreply, mission}
  end

  def terminate(:normal, _room) do
    IO.puts "closing a room!"
  end

  def terminate(reason, room) do
    IOP.inspect {reason, room}, "Room Server terminate args"
    MissionBackup.put(room)
  end

  # *** *******************************
  # *** RETURN TUPLES

  defp ok(room), do: {:ok, room, send_all()}

  defp noreply(room), do: {:noreply, room, send_all()}

  defp reply(room), do: {:reply, room, room, send_all()}

  defp reply(room, return_value), do: {:reply, return_value, room, send_all()}

  defp send_all, do: {:continue, :send_all_players}

end
