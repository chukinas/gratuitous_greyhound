# TODO rename *.Homepage
defmodule ChukinasWeb.DreadnoughtIndexLive do

  use ChukinasWeb, :live_view
  use Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Dreadnought.Unit

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, _session, socket) do
    start_new_turn_timer()
    socket = assign_mission_and_unit(socket, MissionBuilder.homepage())
    {:ok, socket}
  end

  @impl true
  def handle_info(:new_turn, socket) do
    start_new_turn_timer()
    socket = update(socket, :mission, &MissionBuilder.homepage_1_fire_upon_2/1)
    {:noreply, socket}
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp assign_mission_and_unit(socket, mission) do
    socket
    |> assign(mission: mission)
    |> assign(unit: mission |> Mission.unit_by_id(1) |> wrap_unit)
    |> assign(turn_number: Mission.turn_number(mission))
  end

  defp wrap_unit(%Unit{} = unit) do
    scale = 3
    %{
      unit: unit |> IOP.inspect("live - unit 1"),
      scale: scale,
      height: scale * Unit.width(unit)
    }
  end

  defp start_new_turn_timer do
    Process.send_after self(), :new_turn, 100_000
  end

end
