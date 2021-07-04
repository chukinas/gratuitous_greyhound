defmodule ChukinasWeb.DreadnoughtPlayView do

  use ChukinasWeb, :view
  alias Chukinas.Dreadnought.Unit.Event, as: Ev

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
