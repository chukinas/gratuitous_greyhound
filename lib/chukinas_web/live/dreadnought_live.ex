defmodule ChukinasWeb.DreadnoughtLive do

  use ChukinasWeb.DreadnoughtLiveViewHelpers, :menus

  # *** *******************************
  # *** MOUNT, PARAMS

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_page_title
      |> assign_uuid_and_mission(session)
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "ocean.html"}}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    if live_action?(socket, :setup) && mission_in_progress?(socket) do
      path = Routes.dreadnought_main_path(socket, :play)
      send self(), {:push_redirect, path}
    end
    header =
      case socket.assigns.live_action do
        :gallery -> "Gallery"
        _ -> "Dreadnought"
      end
    socket
    |> assign(header: header)
    |> noreply
  end

  # *** *******************************
  # *** HANDLE_INFO

  @impl true
  def handle_info({:update_child_component, live_component, assigns}, socket) do
    send_update(live_component, assigns)
    {:noreply, socket}
  end

  # *** *******************************
  # *** HELPERS

end
