defmodule ChukinasWeb.SkiesView do
  use ChukinasWeb, :view
  # use ChukinasWeb, :live_view

  def render_component(view_model, key) do
    build Atom.to_string(key), Map.fetch!(view_model, key)
  end

  defp build(name, assigns) do
    template = [name, ".html"] |> Enum.join("")
    Phoenix.View.render(__MODULE__, template, assigns)
  end
end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
