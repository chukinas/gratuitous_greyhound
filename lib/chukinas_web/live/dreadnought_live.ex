alias Chukinas.Dreadnought.{Mission, Unit, Command, CommandQueue, CommandIds}
alias Chukinas.Geometry.{Pose}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def mount(_params, _session, socket) do
    mission =
      Mission.new()
    # TODO move all this stuff out into separate module, maybe `MissionBuilder`
      |> Mission.set_arena(1000, 750)
      |> Mission.put(Unit.new(2, start_pose: Pose.new(0, 0, 45)))
      |> Mission.put(CommandQueue.new 2, [Command.new(id: 1, angle: -40, state: :in_hand)])
      |> Mission.issue_command(CommandIds.new 2, 1, 5)
    socket =
      socket
      |> assign(page_title: "Dreadnought")
      |> assign(mission: mission)
    {:ok, socket}
  end

  @impl true
  def handle_event("game_over", _, socket) do
    socket.assigns.mission
    |> Map.put(:state, :game_over)
    |> assign_mission(socket)
  end

  @impl true
  def handle_event("start_game", _, socket) do
    socket.assigns.mission
    |> Map.put(:state, :playing)
    |> assign_mission(socket)
  end

  defp assign_mission(mission, socket) do
    {:noreply, assign(socket, :mission, mission)}
  end
end
