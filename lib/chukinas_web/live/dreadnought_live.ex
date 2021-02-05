defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Unit
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(units: [Unit.new()])
    |> assign(time_checks: [])
    {:ok, socket}
  end

  def handle_event("check_time", %{"rand" => rand}, socket) do
    time_checks = [rand | socket.assigns.time_checks]
    {:noreply, assign(socket, :time_checks, time_checks)}
  end
end
