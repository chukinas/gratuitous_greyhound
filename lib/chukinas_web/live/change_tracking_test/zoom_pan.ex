defmodule ChukinasWeb.ZoomPanLive do
  use ChukinasWeb, :live_view

  def render(assigns) do
    ~L"""
    <style>
      body {
        touch-action:none
      }
    </style>
    <div class="fixed inset-0 bg-black">
    </div>
    <div class="fixed inset-0">
      <div
        class="bg-cat bg-cover"
        style="width:2100px;height:2000px;padding:500px"
        draggable=false
        id="world"
        phx-hook="Pan"
      >
        <div
          id="arena-margin"
          class="bg-green-500 bg-opacity-50"
          style="width:1100px;height:1000px;padding:50px;touch-action:none"
        >
          Arena Margin
          <div
            class="bg-yellow-500 bg-opacity-50"
            style="height:750px;touch-action:none"
          >
            Arena
          </div>
        </div>
      </div>
    </div>
    <button
      id="btnResize"
      class="fixed bg-red-400 bottom-8 inset-x-8 p-8 text-center h-64 bg-opacity-80"
      phx-hook="RefitArena"
    >
      Click here to resize the arena
    </button>
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
