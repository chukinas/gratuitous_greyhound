defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  def build_svg_arrow_shaft(angle) do
    "m 3 10 q 0 -4, 4 -4"
  end

  def build_svg_arrow_head(angle) do
    "m 6.8 3.7 0.83 -1.6 -1.9 -0.17 0.89 0.71 z"
  end
end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://www.wyeworks.com/blog/2020/03/03/breaking-up-a-phoenix-live-view/
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
