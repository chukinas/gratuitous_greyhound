defmodule Chukinas.Skies.ViewModel.Phase do

  alias Chukinas.Skies.Game.Phase, as: G_Phase

  # *** *******************************
  # *** TYPES

  defstruct [
    :name,
    :maybe_current_phase_id,
    :subphases,
    :active?,
    :active_child?,
  ]

  @type phase :: %{
    name: String.t(),
    maybe_current_phase_id: String.t(),
    subphases: [phase()],
    active?: boolean(),
    active_child?: boolean(),
  }

  @type t :: [phase]

  # *** *******************************
  # *** BUILD

  @spec build(G_Phase.t()) :: t()
  def build(phase) do
    G_Phase.all()
    |> Enum.map(&replace_nil_parent/1)
    |> Enum.chunk_by(fn {_, parent} -> parent end)
    |> Enum.map(&build_phase(&1, phase))
  end

  # *** *******************************
  # *** HELPERS

  defp replace_nil_parent({this, parent}) when is_nil(parent), do: {this, this}
  defp replace_nil_parent({this, parent}), do: {this, parent}

  defp build_phase([{phase_name, _}], active_phase_name) do
    active? = phase_name == active_phase_name
    %__MODULE__{
      name: to_display_string(phase_name),
      maybe_current_phase_id: if active? do "id=\"current_phase\"" end,
      subphases: [],
      active?: active?,
      active_child?: false
    }
  end
  defp build_phase([{_, parent} | _] = phases, active_phase_name) do
    children = phases
    |> Enum.map(&build_phase(&1, active_phase_name))
    active_child? = children
    |> Enum.any?(fn c -> c.active end)
    %__MODULE__{
      name: to_display_string(parent),
      maybe_current_phase_id: nil,
      subphases: children,
      active?: false,
      active_child?: active_child?,
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
