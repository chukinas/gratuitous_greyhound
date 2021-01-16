defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view
  alias Chukinas.Dreadnought.Cartesian

  def build_arrow_svg_paths(angle_deg) do
    %{shaft: build_svg_arrow_shaft(angle_deg), head: build_svg_arrow_head(angle_deg)}
  end

  # TODO move to a dedicated module
  defp build_svg_arrow_shaft(angle) do
    "m 3 10 #{build_svg_arrow_shaft_curve(angle)}"
  end

  defp build_svg_arrow_head(angle) do
    "m 6.8 3.7 0.83 -1.6 -1.9 -0.17 0.89 0.71 z"
  end

  defp build_svg_arrow_shaft_curve(angle) do
    # TODO change length to a module property
    # TODO move these helpers to a new module
    path_len = 10
    "q 0 -#{path_len/2}, 4 -4"
  end

end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://www.wyeworks.com/blog/2020/03/03/breaking-up-a-phoenix-live-view/
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
