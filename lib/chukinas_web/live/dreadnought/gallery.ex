defmodule ChukinasWeb.DreadnoughtLive.Gallery do

  use ChukinasWeb, :live_view

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(header: "Gallery")
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "ocean.html"}}
  end

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def handle_event("toggle_show_markers", _, socket) do
    socket =
      socket
      |> assign(show_markers?: !socket.assigns[:show_markers?])
    {:noreply, socket}
  end

end
