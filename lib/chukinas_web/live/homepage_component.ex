defmodule ChukinasWeb.HomepageComponent do

  use ChukinasWeb, :live_component
  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.MissionBuilder.Homepage, as: HomepageMission
  alias Chukinas.Dreadnought.Unit

  # *** *******************************
  # *** MOUNT, PARAMS, UPDATE

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign_buttons
      |> assign_mission(HomepageMission.new())
    {:ok, socket}
  end

  @doc"""
  This callback fires after mount and every ___ seconds.
  Because a live component cannot send a timed event to itself.
  In order to regularly update the unit's turrets,
  I have to send a message to the parent liveview that forces
  this child to update.
  """
  @impl true
  def update(assigns, socket) do
    msg = {:update_child_component, __MODULE__, id: assigns.id}
    Process.send_after self(), msg, 3500
    mission = HomepageMission.next_gunfire(socket.assigns.mission)
    socket = assign_mission(socket, mission)
    {:ok, socket}
  end

  # *** *******************************
  # *** HANDLE_EVENT

  @impl true
  def handle_event("button_click", %{"route" => route}, socket) do
    {:noreply, redirect(socket, to: route)}
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
        button_map(socket, "Play", :setup),
        button_map(socket, "Quick Demo", :demo),
        button_map(socket, "Gallery", :gallery)
      ]
    assign(socket, buttons: buttons)
  end

  defp button_map(socket, title, live_action) do
    %{
      content: title,
      attrs: [
        phx_click: "button_click",
        phx_target: socket.assigns.myself,
        phx_value_route: Routes.dreadnought_main_path(socket, live_action)
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
