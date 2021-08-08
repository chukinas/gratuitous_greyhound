defmodule ChukinasWeb.DreadnoughtLive.HomepageComponent do

  use ChukinasWeb, :live_component
  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.MissionBuilder.Homepage, as: HomepageMission
  alias Chukinas.Dreadnought.Unit

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign_buttons
      |> assign_mission(HomepageMission.new())
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    msg = {:update_child_component, __MODULE__, id: assigns.id}
    Process.send_after self(), msg, 3500
    mission = HomepageMission.next_gunfire(socket.assigns.mission)
    socket = assign_mission(socket, mission)
    {:ok, socket}
  end

  @impl true
  def handle_event("redirect", %{"value" => action}, socket) do
    route =
      case action do
        "play" -> Routes.dreadnought_path(socket, :setup)
        "gallery" -> Routes.dreadnought_gallery_path(socket, :gallery)
      end
    {
      :noreply,
      redirect(socket, to: route)
    }
  end

  @impl true
  def handle_event("next_unit", _, socket) do
    mission = HomepageMission.next_unit(socket.assigns.mission)
    socket = assign_mission(socket, mission)
    {:noreply, socket}
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp assign_buttons(socket) do
    buttons =
      [
        button_map(socket,"Play"),
        button_map(socket,"Gallery")
      ]
    assign(socket, buttons: buttons)
  end

  defp button_map(socket, title) do
    %{
      content: title,
      attrs: [
        phx_click: "redirect",
        phx_target: socket.assigns.myself,
        value: title |> String.downcase
      ]
    }
  end

  defp assign_mission(socket, mission) do
    socket
    |> assign(mission: mission)
    |> assign(unit: mission |> HomepageMission.main_unit |> wrap_unit)
    |> assign(turn_number: HomepageMission.turn_number(mission))
  end

  defp wrap_unit(%Unit{} = unit) do
    scale = 3
    %{
      unit: unit,
      scale: scale,
      height: scale * Unit.width(unit) + 100
    }
  end

end
