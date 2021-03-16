alias Chukinas.Dreadnought.{MissionBuilder, Mission}

defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias ChukinasWeb.DreadnoughtView
  alias ChukinasWeb.Dreadnought

  @impl true
  def mount(_params, _session, socket) do
    # TODO remove?
    mission =
      MissionBuilder.demo
      |> Mission.build_view
    socket =
      socket
      |> assign(page_title: "Dreadnought")
      |> assign(mission: mission)
      |> assign(player_id: 1)
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, url, socket) do
    socket = case socket.assigns.live_action do
      :play -> assign(socket, :mission, MissionBuilder.demo |> Mission.build_view)
      _ -> socket
    end
    if String.ends_with?(url, "dreadnought/") or String.ends_with?(url, "dreadnought") do
      {:noreply, push_patch(socket, to: "/dreadnought/welcome")}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("route_to", %{"route" => route}, socket) do
    {:noreply, push_patch(socket, to: route)}
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
