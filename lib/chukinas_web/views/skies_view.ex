defmodule ChukinasWeb.SkiesView do
  use ChukinasWeb, :view

  def space() do
    Phoenix.View.render(__MODULE__, "space.html", name: "harry")
  end
end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
