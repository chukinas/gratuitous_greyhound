defmodule DreadnoughtWeb.TerrainView do

  use DreadnoughtWeb, :view
  #alias Dreadnought.Core.Island
  alias Dreadnought.Core.Island.Builder

  def crinkled_paper_path(socket) do
    Routes.static_path socket, "/images/crinkled_paper_20210517.jpg"
  end

  def dropshadow(socket) do
    assigns = %{path: Routes.static_path(socket, "/defs.svg"), __changed__: false}
    ~L"""
    filter="url(<%= @path %>#dropshadow)"
    """
  end

  @doc"""
  This must be rendered within an svg tag.
  """
  def render_islands(island_specs) when is_list(island_specs) do
    render("islands_top_level.html", island_specs: island_specs)
  end
  # TODO deprecated
  def render_islands(socket) do
    render("islands.html", socket: socket)
  end

  defp render_island_defs(island_specs) do
    # TODO move this chunk to Island.Spec.Enum
    island_shapes =
      island_specs
      |> Stream.map(&elem(&1, 0))
      |> MapSet.new
      |> MapSet.to_list
      |> IOP.inspect(__MODULE__)
    render("island_defs.html", shapes: island_shapes)
  end

  defp render_island_def(shape) when is_atom(shape) do
    render("island_def.html",
      shape_id: shape,
      polygon_points: Builder.svg_polygon_points_string(shape)
    )
  end

end
