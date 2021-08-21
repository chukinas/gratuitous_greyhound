defmodule DreadnoughtWeb.TerrainView do

  use DreadnoughtWeb, :view

  def crinkled_paper_path(socket) do
    Routes.static_path socket, "/images/crinkled_paper_20210517.jpg"
  end

  def dropshadow(socket) do
    assigns = %{path: Routes.static_path(socket, "/defs.svg"), __changed__: false}
    ~L"""
    filter="url(<%= @path %>#dropshadow)"
    """
  end

  # TODO deprecated
  def render_islands(socket) do
    render("islands.html", socket: socket)
  end

end
