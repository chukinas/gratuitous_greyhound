# TODO rename *.Homepage
defmodule ChukinasWeb.DreadnoughtIndexLive do

  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.Mission
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Dreadnought.Unit

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(mission: MissionBuilder.homepage())
      |> assign_wrapped_unit
    {:ok, socket}
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp assign_wrapped_unit(socket) do
    assign(
      socket,
      unit: socket.assigns.mission
            |> Mission.unit_by_id(1)
            |> unit_to_positioning_map
    )
  end

  defp unit_to_positioning_map(%Unit{} = unit) do
    scale = 3
    %{
      unit: unit,
      scale: scale,
      height: scale * Unit.width(unit)
    }
  end

end
