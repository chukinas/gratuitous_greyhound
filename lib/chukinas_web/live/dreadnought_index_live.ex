# TODO rename *.Homepage
defmodule ChukinasWeb.DreadnoughtIndexLive do

  use ChukinasWeb, :live_view
  alias Chukinas.Dreadnought.MissionBuilder
  alias Chukinas.Dreadnought.Unit
  # TODO rename *.UnitBuilder
  alias Chukinas.Dreadnought.Unit.Builder, as: UnitBuilder

  # *** *******************************
  # *** CALLBACKS (MOUNT/PARAMS)

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(mission: MissionBuilder.homepage())
      |> assign(:unit, UnitBuilder.red_cruiser(1, 1) |> unit_to_positioning_map)
    {:ok, socket}
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp unit_to_positioning_map(%Unit{} = unit) do
    unit = Unit.position_mass_center(unit)
    scale = 3
    %{
      unit: unit,
      scale: scale,
      height: scale * Unit.width(unit)
    }
  end

end
