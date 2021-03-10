alias Chukinas.Dreadnought.{MissionBuilder, Mission}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  alias ChukinasWeb.Dreadnought

  @impl true
  def mount(_params, _session, socket) do
    mission =
      MissionBuilder.demo()
      |> Mission.build_view
    #   |> Map.put(:state, :playing)
    socket =
      socket
      |> assign(page_title: "Dreadnought")
      |> assign(mission: mission)
      |> assign(player_id: 1)
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

  @impl true
  def handle_event("select_command", %{"id" => id}, socket) do
    socket.assigns.mission
    |> Mission.select_command(socket.assigns.player_id, String.to_integer(id))
    |> assign_mission(socket)
  end

  @impl true
  def handle_event("issue_command", %{"step_id" => step_id}, socket) do
    socket.assigns.mission
    |> Mission.issue_selected_command(step_id)
    |> assign_mission(socket)
  end

  defp assign_mission(mission, socket) do
    {:noreply, assign(socket, :mission, mission |> Mission.build_view)}
  end
end
