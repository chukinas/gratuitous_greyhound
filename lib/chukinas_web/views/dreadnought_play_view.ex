defmodule ChukinasWeb.DreadnoughtPlayView do

  use ChukinasWeb, :view
  alias Chukinas.Dreadnought.Unit.Event, as: Ev
  alias Chukinas.Geometry.Grid

  def maneuver_paths(units, %Grid{} = grid) do
    assigns =
      grid
      |> Grid.size
      #|> Map.put(:actions, Enum.flat_map(units, &Unit.events(&1, :current)))
      |> Map.put(:units, units)
    render "maneuvers.html", assigns
  end

  def maneuver_path(%Ev.Maneuver{} = path, unit_id) do
    assigns =
      path
      |> Map.from_struct
      |> Map.put(:unit_el_id, "unit-#{unit_id}")
    render("maneuver_path.html", assigns)
  end

  def maneuver_path(_, _) do
    nil
  end

end
