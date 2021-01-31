defmodule ChukinasWeb.DreadnoughtLive do
  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Deck
  alias ChukinasWeb.DreadnoughtView

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(page_title: "Dreadnought")
    |> assign(deck: Deck.new(1) |> Deck.draw(1))
    |> assign(time_checks: [])
    {:ok, socket}
  end

  def handle_event("check_time", _value, socket) do
    time_checks = ["something" | socket.assigns.time_checks]
    {:noreply, assign(socket, :time_checks, time_checks)}
  end
end
