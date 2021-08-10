defmodule ChukinasWeb.DreadnoughtLive.Index do

  use ChukinasWeb, :live_view

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "ocean.html"}}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    IOP.inspect self()
    header =
      case socket.assigns.live_action do
        :homepage -> "Dreadnought"
        :gallery -> "Gallery"
      end
    socket = assign(socket, header: header)
    {:noreply, socket}
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

  @impl true
  def handle_info({:update_child_component, live_component, assigns}, socket) do
    send_update(live_component, assigns)
    {:noreply, socket}
  end

end
