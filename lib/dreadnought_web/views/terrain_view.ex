defmodule DreadnoughtWeb.TerrainView do

  use DreadnoughtWeb, :view
  #alias Dreadnought.Core.Island

  def crinkled_paper_path(socket) do
    Routes.static_path socket, "/images/crinkled_paper_20210517.jpg"
  end

  def render_islands(socket) do
    render("islands.html", socket: socket)
  end

end
