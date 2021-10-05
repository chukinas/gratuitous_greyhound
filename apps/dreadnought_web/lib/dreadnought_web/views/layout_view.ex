defmodule DreadnoughtWeb.LayoutView do

  use DreadnoughtWeb, :view
  use Spatial.LinearAlgebra
  use Spatial.PositionOrientationSize
  alias DreadnoughtWeb.LayoutView.OceanTile

  @col_count 10
  @row_count 10
  @ocean_tiles OceanTile.Enum.from_col_and_row_counts(@col_count, @row_count)

  def ocean_tiles, do: @ocean_tiles

  def render_layout(layout, assigns, do: content) do
    assigns =
      assigns
      |> Map.new
      |> Map.put(:inner_content, content)
    render(layout, assigns)
  end

end
