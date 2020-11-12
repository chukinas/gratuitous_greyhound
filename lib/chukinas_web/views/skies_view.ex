defmodule ChukinasWeb.SkiesView do
  use ChukinasWeb, :view

  def build_component_renderer(vm) do
    fn view_model_key -> render_component(vm, view_model_key) end
  end

  # TODO some day, this should be private
  def render_component(key) do
    build Atom.to_string(key)
  end

  def render_component(view_model, key) do
    build Atom.to_string(key), Map.fetch!(view_model, key)
  end

  defp build(name, assigns \\ []) do
    template = [name, ".html"] |> Enum.join("")
    Phoenix.View.render(__MODULE__, template, assigns)
  end

  defp phase_class(:in_progress), do: "bg-indigo-100  font-extrabold"
  defp phase_class(:sub_in_progress), do: "bg-indigo-100 font-normal"
  defp phase_class(:other), do: "font-normal"
end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
