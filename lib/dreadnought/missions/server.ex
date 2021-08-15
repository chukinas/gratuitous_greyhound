defmodule Dreadnought.Missions.Server do

  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Missions.Backup
  alias Dreadnought.Missions.Registry, as: MissionRegistry
  alias Dreadnought.Multiplayer
  alias Dreadnought.Players
  use GenServer

  # *** *******************************
  # *** CLIENT

  def child_spec(mission_name) do
    %{
      id: mission_name,
      start: {__MODULE__, :start_link, [mission_name]}
    }
  end

  def start_link(mission_name) do
    GenServer.start_link(
      __MODULE__,
      mission_name,
      name: MissionRegistry.build_name(mission_name)
    )
  end

  # *** *******************************
  # *** CALLBACKS: INIT

  @impl true
  def init(mission_name) when is_binary(mission_name) do
    mission = case Backup.fetch_and_pop(mission_name) do
      {:ok, mission} -> mission
      :error -> Multiplayer.new_mission(mission_name)
    end
    ok_then_send_all(mission)
  end

  # *** *******************************
  # *** CALLBACKS: HANDLE_CALL

  @impl true
  def handle_call({:add_player, %Player{} = player}, _from, mission) do
    mission = Mission.add_player(mission, player)
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
    # TODO remove from Backup
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
