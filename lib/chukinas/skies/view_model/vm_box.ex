defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Common, as: C
  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.Game.EscortStation, as: G_EscortStation
  alias Chukinas.Skies.Game.Escorts, as: G_Escorts
  alias Chukinas.Skies.Game.FighterGroups, as: G_FighterGroups
  alias Chukinas.Skies.ViewModel.GroupPawns, as: VM_GroupPawns

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :title, String.t()
    field :uiid, String.t()
    field :fighter_group_pawns, VM_GroupPawns.t()
    field :escort_pawns, VM_GroupPawns.t()
    field :grid_tailwind, String.t()
  end

  # *** *******************************
  # *** BUILD

  @spec build_fighter_box(G_Box.t(), G_FighterGroups.t()) :: t()
  def build_fighter_box(%G_Box{} = box, all_groups) do
    %__MODULE__{
      title: build_title(box.id),
      uiid: box.id |> G_Box.id_to_uiid(),
      fighter_group_pawns: VM_GroupPawns.build(box.id, all_groups),
      escort_pawns: [],
      grid_tailwind: grid_tailwind(box.id)
    }
  end

  @spec build_escort_station(G_EscortStation.id(), G_Escorts.t()) :: t()
  def build_escort_station(escort_station_name, _escorts) do
    %__MODULE__{
      title: build_title(escort_station_name),
      uiid: escort_station_name |> Atom.to_string(),
      fighter_group_pawns: [],
      escort_pawns: [],
      grid_tailwind: grid_tailwind(escort_station_name)
    }
  end

  # *** *******************************
  # *** HELPERS - TITLE

  @spec build_title(G_Box.id()) :: String.t()
  # TODO replace with case in single func
  defp build_title({_, :approach, _}), do: "Approach"
  defp build_title({_, :preapproach, alt}), do: build_title(alt)
  defp build_title({_, {:return, :evasive}, _}), do: "Evasive Return"
  defp build_title({_, {:return, _}, _}), do: "Return"
  defp build_title(:notentered), do: "Not Entered"
  defp build_title(:abovetrailing), do: "Above Trailing"
  defp build_title(:belowtrailing), do: "Below Trailing"
  defp build_title(id) when is_atom(id) do
    Atom.to_string(id) |> String.capitalize()
  end

  # *** *******************************
  # *** HELPERS - GRID

  @spec grid_tailwind(G_EscortStation.id() | G_Box.id()) :: String.t()
  defp grid_tailwind(:abovetrailing), do: build_tailwind({2, 1})
  defp grid_tailwind(:forward),       do: build_tailwind({1, 2})
  defp grid_tailwind(:belowtrailing), do: build_tailwind({2, 3})
  defp grid_tailwind(g_box) do
    build_tailwind({
      grid_col(g_box),
      grid_row(g_box),
    })
  end

  @spec build_tailwind(C.coordinates()) :: String.t()
  defp build_tailwind({x, y}), do: "row-start-#{y} col-start-#{x}"

  @spec grid_row(G_Box.id()) :: integer()
  defp grid_row({_, _, altitude}) do
    [nil, :high, :level, :low]
    |> Enum.find_index(&(&1 == altitude))
  end
  defp grid_row(_), do: 0

  @spec grid_col(G_Box.id()) :: integer()
  defp grid_col({_, box_type, _}) do
    case box_type do
      {_, :evasive}    -> 1
      {_, :determined} -> 2
          :preapproach -> 3
          :approach    -> 4
    end
  end
  defp grid_col(_), do: 0

end
