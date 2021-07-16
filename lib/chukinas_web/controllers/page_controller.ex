defmodule ChukinasWeb.PageController do
  use ChukinasWeb, :controller
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Dreadnought.Unit.Builder

  def index(conn, _params) do
    render conn, "index.html"
  end

  def minis(conn, _params) do
    render conn, "minis.html"
  end

  def music(conn, _params) do
    render conn, "music.html"
  end

  def dev(conn, _params) do
    conn = assign(conn, :unit, Builder.red_cruiser(1, 1) |> unit_to_positioning_map)
    render conn, "homepage.html"
  end

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
