defmodule ChukinasWeb.ZoomPanLive do
  use ChukinasWeb, :live_view

  def render(assigns) do
    ~L"""
    <style>
      body {
        touch-action:none
      }
    </style>
    <div id="zoomEl" class="bg-indigo-200" phx-hook="Pan">
      <svg
        width="1080"
        height="920"
        version="1.1"
        viewBox="0 0 140 40"
        xmlns="http://www.w3.org/2000/svg"
        class="fill-current text-green-600"
      >
        <path
          d="m46 7.2c-26 0-42 13-42 13s16 13 42 13c26 0 43-7.5 52-13-9.2-5.3-26-13-52-13z"
          style="stroke-linejoin:round;stroke-width:2.5;stroke:#fff"
        />
      </svg>
    </div>
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
