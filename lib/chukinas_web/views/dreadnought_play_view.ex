defmodule ChukinasWeb.DreadnoughtPlayView do

  use ChukinasWeb, :view
  alias Chukinas.Dreadnought.Unit.Event.Maneuver

  def render_single_maneuver(%Maneuver{} = path, unit_id) do
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
