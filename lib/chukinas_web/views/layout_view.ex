defmodule ChukinasWeb.LayoutView do
  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias ChukinasWeb.LayoutView.OceanTile

  @col_count 10
  @row_count 10
  @ocean_tiles OceanTile.Enum.from_col_and_row_counts(@col_count, @row_count)


  def crinkled_paper_path(socket) do
    Routes.static_path socket, "/images/crinkled_paper_20210517.jpg"
  end

  def ocean_tiles, do: @ocean_tiles

  #def ocean_with_header(socket, flash, do) do
  #end

  def render_layout(layout, assigns, do: content) do
    assigns =
      assigns
      |> Map.new
      |> Map.put(:inner_content, content)
    render(layout, assigns)
  end

end
