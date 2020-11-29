defmodule Chukinas.Skies.ViewModel.Phase do

  alias Chukinas.Skies.Game.Phase, as: G_Phase

  # *** *******************************
  # *** TYPES

  defstruct [
    :name,
    :subphases,
    :active?,
    :active_child?,
    :has_children?,
  ]

  @type phase :: %{
    name: String.t(),
    subphases: [phase()],
    active?: boolean(),
    active_child?: boolean(),
    has_children?: boolean(),
  }

  @type t :: [phase]

  # *** *******************************
  # *** BUILD

  @spec build(G_Phase.t()) :: t()
  def build(%G_Phase{} = phase) do
    result = G_Phase.all()
    |> Enum.map(&replace_nil_parent/1)
    |> Enum.chunk_by(fn {_, parent} -> parent end)
    |> Enum.map(&build_phase(&1, phase))
    if phase.name == :approach do
      IO.inspect(result, label: "approach is active?")
    end
    result
  end

  # *** *******************************
  # *** HELPERS

  defp replace_nil_parent({this, parent}) when is_nil(parent), do: {this, this}
  defp replace_nil_parent({this, parent}), do: {this, parent}

  defp build_phase({_, _} = phase, g_phase), do: build_phase([phase], g_phase)
  defp build_phase([{phase_name, _}], g_phase) do
    active? = g_phase.is?.(phase_name)
    %__MODULE__{
      name: to_display_string(phase_name),
      subphases: [],
      active?: active?,
      active_child?: false,
      has_children?: false,
    }
  end
  defp build_phase([{_, parent} | _] = phases, g_phase) do
    children = phases
    |> Enum.map(&build_phase(&1, g_phase))
    %__MODULE__{
      name: to_display_string(parent),
      subphases: children,
      active?: false,
      active_child?: g_phase.parent == parent,
      has_children?: true,
    }
  end

  @spec to_display_string(G_Phase.phase_name()) :: String.t
  defp to_display_string(phase) when is_atom(phase) do
    case phase do
      :blast_flak -> "Blast & Flak"
      :break_away -> "Break Away"
      _ -> phase
        |> Atom.to_string()
        |> String.capitalize()
    end
  end

end
