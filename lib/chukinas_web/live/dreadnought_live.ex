defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Mission
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(mission: Mission.new())
    {:ok, socket}
  end

  @impl true
  def handle_event("game_over", _, socket) do
    mission = socket.assigns.mission
              |> Map.put(:state, :game_over)
    {:noreply, assign(socket, :mission, mission)}
  end
end
