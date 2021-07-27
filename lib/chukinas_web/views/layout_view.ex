defmodule ChukinasWeb.LayoutView do
  use ChukinasWeb, :view
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias ChukinasWeb.LayoutView.OceanSquare, as: OceanTile

  @col_count 2
  @row_count 5
  #@ocean_tiles OceanSquare.Enum.from_col_and_row_counts(@col_count, @row_count)
  @ocean_tiles [OceanTile.from_position position_origin()]


  def crinkled_paper_path(socket) do
    Routes.static_path socket, "/images/crinkled_paper_20210517.jpg"
  end

  def ocean_tiles, do: @ocean_tiles

end
