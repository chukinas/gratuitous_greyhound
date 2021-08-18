defmodule Dreadnought.Missions.Server do

  use Dreadnought.Core.Mission.Spec
  use GenServer
  alias Dreadnought.Core.Mission
  alias Dreadnought.Core.Player
  alias Dreadnought.Missions.Backup
  alias Dreadnought.Missions.Registry, as: MissionRegistry
  alias Dreadnought.Players

  # *** *******************************
  # *** CLIENT

  def child_spec(mission_spec) when is_mission_spec(mission_spec) do
    IOP.inspect "child_spec", __MODULE__
    %{
      id: mission_spec,
      start: {__MODULE__, :start_link, [mission_spec]}
    }
  end

  def start_link(mission_spec) when is_mission_spec(mission_spec) do
    IOP.inspect mission_spec, __MODULE__
    GenServer.start_link(
      __MODULE__,
      mission_spec,
      name: MissionRegistry.build_name(mission_spec) |> IOP.inspect(__MODULE__)
    )
  end

  # *** *******************************
  # *** CALLBACKS: INIT

  @impl true
  def init(mission_spec) when is_mission_spec(mission_spec) do
    IOP.inspect "init", __MODULE__
    mission = case Backup.fetch_and_pop(mission_spec) do
      {:ok, mission} -> mission |> IOP.inspect(__MODULE__)
      :error -> build_mission(mission_spec) |> IOP.inspect(__MODULE__)
    end
    #ok_then_send_all(mission)
    {:ok, mission}
    IOP.inspect "init", __MODULE__
  end

  # TODO move to Mission.Builder
  defp build_mission({mission_builder_module, mission_name} = mission_spec)
  when is_mission_spec(mission_spec) do
    apply(mission_builder_module, :new, [mission_name])
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

  #defp ok_then_send_all(room) do
  #  {:ok, room, {:continue, :send_all_players}}
  #end

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
