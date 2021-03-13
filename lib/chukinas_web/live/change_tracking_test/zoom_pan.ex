defmodule ChukinasWeb.ZoomPanLive do
  use ChukinasWeb, :live_view

  def render(assigns) do
    ~L"""
    <style>
      body {
        touch-action:none
      }
    </style>
    <div class="fixed inset-0">
      <div
        class="bg-cat w-1/2 h-1/2 bg-cover"
        draggable=false
        id="pannable"
        phx-hook="Pan"
      >
      </div>
    </div>
    <h1 class="fixed bg-red-400 bottom-8 inset-x-8 p-8 text-center h-64 bg-opacity-50">Fixed Element</h1>
    <div class="bg-blue-300 opacity-50 fixed h-1/3 w-1/3 left-1/3 top-1/3"> </div>
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
