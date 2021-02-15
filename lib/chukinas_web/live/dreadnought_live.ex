defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Mission
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(mission: Mission.new() |> IO.inspect(label: "mission"))
    {:ok, socket}
  end

  @impl true
  def handle_event("check_time", %{"rand" => rand}, socket) do
    time_checks = [rand | socket.assigns.time_checks]
    {:noreply, assign(socket, :time_checks, time_checks)}
  end
end
