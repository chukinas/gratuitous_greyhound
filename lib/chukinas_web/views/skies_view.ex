defmodule ChukinasWeb.SkiesView do
  use ChukinasWeb, :view
  # use ChukinasWeb, :live_view

  def escort_stations() do
    ~E"""
    Here are escort stations
    """
  end

  def space(name \\ nil) do
    # Phoenix.View.render(__MODULE__, "space.html", name: "name")
    build "space", %{name: name}
  end

  defp build(name, assigns) do
    template = [name, ".html"] |> Enum.join("")
    Phoenix.View.render(__MODULE__, template, assigns)
  end
end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
