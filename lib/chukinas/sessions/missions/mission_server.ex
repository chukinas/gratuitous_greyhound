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
  # *** CALLBACKS: INIT

  @impl true
  def init(room_name) when is_binary(room_name) do
    mission = case MissionBackup.fetch_and_pop(room_name) do
      {:ok, mission} -> mission
      :error -> MissionBuilder.online(room_name)
    end
    ok_then_send_all(mission)
  end

  # *** *******************************
  # *** CALLBACKS: HANDLE_CALL

  @impl true
  def handle_call({:add_player, %{
    player_name: player_name,
    player_uuid: player_uuid,
  }}, _from, mission) do
    mission = MissionBuilder.add_player(mission, player_uuid, player_name)
    reply_then_send_all(mission, :ok)
  end

  def handle_call(:get, _from, mission) do
    {:reply, mission, mission}
  end

  # *** *******************************
  # *** CALLBACKS: HANDLE_CAST

  @impl true
  def handle_cast({:drop_player, player_uuid}, mission) do
    Players.send_room(player_uuid, nil)
    mission = Mission.drop_player_by_uuid(mission, player_uuid)
    if Mission.empty?(mission), do: Process.exit(self(), :normal)
    noreply_then_send_all(mission)
  end

  @impl true
  def handle_cast({:toggle_ready, player_id}, mission) do
    mission
    |> Mission.toggle_player_ready_by_id(player_id)
    |> noreply_then_send_all
  end

  # TODO deprecate
  def handle_cast({:update_mission, func}, mission) do
    func.(mission) |> noreply_then_send_all
  end

  # *** *******************************
  # *** CALLBACKS: HANDLE_CONTINUE

  @impl true
  def handle_continue(:send_all_players, mission) do
    mission
    |> send_all
    |> noreply
  end

  # *** *******************************
  # *** CALLBACKS: TERMINATE

  @impl true
  def terminate(:normal, _room) do
  end

  @impl true
  def terminate(_reason, mission) do
    MissionBackup.put(mission)
  end

  # *** *******************************
  # *** HELPERS

  def send_all(mission) do
    for uuid <- Mission.player_uuids(mission) do
      Players.send_room(uuid, mission)
    end
    mission
  end

  # *** *******************************
  # *** RETURN TUPLES

  defp ok_then_send_all(room) do
    {:ok, room, {:continue, :send_all_players}}
  end

  defp noreply(mission) do
    {:noreply, mission}
  end

  defp noreply_then_send_all(mission) do
    {:noreply, mission, {:continue, :send_all_players}}
  end

  #defp reply_then_send_all(mission) do
  #  reply_then_send_all(mission, mission)
  #end

  defp reply_then_send_all(mission, return_value) do
    {:reply, return_value, mission, {:continue, :send_all_players}}
  end

end
