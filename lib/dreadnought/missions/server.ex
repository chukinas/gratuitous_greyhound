defmodule Dreadnought.Missions.Server do

  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.MissionBuilder
  alias Dreadnought.Core.Player
  alias Dreadnought.Missions.Backup
  alias Dreadnought.Missions.Registry, as: MissionRegistry
  alias Dreadnought.Sessions.Players
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
    mission = case Backup.fetch_and_pop(room_name) do
      {:ok, mission} -> mission
      :error -> MissionBuilder.online(room_name)
    end
    ok_then_send_all(mission)
  end

  # *** *******************************
  # *** CALLBACKS: HANDLE_CALL

  @impl true
  def handle_call({:add_player, %Player{uuid: uuid, name: name}}, _from, mission) do
    # TODO this fun should take Player struct
    mission = MissionBuilder.add_player(mission, uuid, name)
    # TODO replay with ok tuple?
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

  def handle_cast({:update_then_send_all, func}, mission) do
    mission
    |> func.()
    |> noreply_then_send_all
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
    Backup.put(mission)
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
