# TODO rename *.Homepage
defmodule ChukinasWeb.DreadnoughtIndexLive do

  use ChukinasWeb, :live_view
  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.MissionBuilder.Homepage, as: HomepageMission
  alias Chukinas.Dreadnought.Unit

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_buttons
      |> assign_mission_and_start_timer(HomepageMission.new())
    {:ok, socket, layout: {ChukinasWeb.LayoutView, "ocean.html"}}
  end

  @impl true
  def handle_info(:new_turn, socket) do
    mission = HomepageMission.next_gunfire(socket.assigns.mission)
    socket = assign_mission_and_start_timer(socket, mission)
    {:noreply, socket}
  end

  @impl true
  def handle_event("redirect", %{"value" => action}, socket) do
    route =
      case action do
        "play" -> Routes.dreadnought_path(socket, :setup)
        "gallery" -> Routes.dreadnought_path(socket, :gallery)
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
        button_map("Play"),
        button_map("Gallery")
      ]
    assign(socket, buttons: buttons)
  end

  defp button_map(title) do
    %{
      title: title,
      action: title |> String.downcase
    }
  end

  defp assign_mission_and_start_timer(socket, mission) do
    Process.send_after self(), :new_turn, Enum.random(3..5) * 1_000
    assign_mission(socket, mission)
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
