defmodule DreadnoughtWeb.TerrainView do

  use DreadnoughtWeb, :view
  #alias Dreadnought.Core.Island

  def render_islands(socket) do
    render("islands.html", socket: socket)
  end

end
