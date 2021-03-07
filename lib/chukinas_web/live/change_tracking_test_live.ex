defmodule ChukinasWeb.ChangeTrackingTestLive do
  use ChukinasWeb, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    hi!
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Change Tracking Test!")
    {:ok, socket}
  end

  @impl true
  def handle_event("game_over", _, socket) do
    socket
  end
end
