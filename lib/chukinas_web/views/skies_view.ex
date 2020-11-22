defmodule ChukinasWeb.SkiesView do
  use ChukinasWeb, :view
  # alias Chukinas.Skies.

  def build_component_renderer(vm) do
    fn view_model_key -> render_component(vm, view_model_key) end
  end

  def render_component(key) do
    build Atom.to_string(key)
  end

  def render_component(view_model, key) do
    build Atom.to_string(key), Map.fetch!(view_model, key)
  end

  defp build(name, assigns \\ [])
  defp build(name, assigns) when is_struct(assigns) do
    build(name, Map.from_struct(assigns))
  end
  defp build(name, assigns) do
    template = [name, ".html"] |> Enum.join("")
    Phoenix.View.render(__MODULE__, template, assigns)
  end

  # *** *******************************
  # *** TURN MANAGER

  defp phase_class(:in_progress), do: "bg-indigo-100  font-bold"
  defp phase_class(:sub_in_progress), do: "bg-indigo-100 font-normal"
  defp phase_class(:other), do: "font-normal"

  def current_phase_id(phase) do
    case phase.status do
      :in_progress -> "id=current_phase"
      _ -> nil
    end
  end

  # *** *******************************
  # *** COMPONENTS

  def button_styling(opts \\ []) do
    opts = Keyword.merge([disabled: false], opts)
    base = """
    bg-blue-500 hover:bg-blue-700
    text-white font-bold
    py-2 px-4 mt-1
    border border-blue-700 rounded
    """
    if Keyword.fetch!(opts, :disabled), do: base <> " opacity-50", else: base
  end

end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
