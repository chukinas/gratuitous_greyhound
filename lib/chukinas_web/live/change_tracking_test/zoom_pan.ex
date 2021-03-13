defmodule ChukinasWeb.ZoomPanLive do
  use ChukinasWeb, :live_view

  def render(assigns) do
    ~L"""
    <style>
      body {
        touch-action:none
      }
    </style>
    <img width="500" draggable=false id="pannable" phx-hook="Pan" src="https://cdn.glitch.com/d824d0c2-e771-4c9f-9fe2-a66b3ac139c5%2Fcats.jpg?1541801135989">
    <h1 class="fixed bg-red-400 bottom-0 inset-x-0 p-8 text-center h-64">Fixed Element</h1>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.6.0/gsap.min.js"></script>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page_title: "Zoom Pan!")
    {:ok, socket}
  end

  def handle_event("log", params, socket) do
    params |> IOP.inspect
    {:noreply, socket}
  end
end
