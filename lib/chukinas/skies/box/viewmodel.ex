defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Common, as: C
  alias Chukinas.Skies.Game.Box, as: GBox
  alias Chukinas.Skies.Game.EscortStation, as: GEscortStation
  alias Chukinas.Skies.Game.Escorts, as: GEscorts
  alias Chukinas.Skies.Game.FighterGroups, as: GFighterGroups
  alias Chukinas.Skies.ViewModel.GroupPawns, as: VFighterGroupPawns

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :title, String.t()
    field :uiid, String.t()
    field :fighter_group_pawns, VFighterGroupPawns.t()
    field :escort_pawns, VFighterGroupPawns.t()
    field :grid_tailwind, String.t()
  end

  # *** *******************************
  # *** BUILD

  @spec build_fighter_box(GBox.t(), GFighterGroups.t()) :: t()
  def build_fighter_box(%GBox{} = g_box, g_fighter_groups) do
    %__MODULE__{
      title: build_title(g_box.id),
      uiid: g_box.id |> GBox.id_to_uiid(),
      fighter_group_pawns: VFighterGroupPawns.build(g_box.id, g_fighter_groups),
      escort_pawns: [],
      grid_tailwind: grid_tailwind(g_box.id)
    }
  end

  @spec build_escort_station(GEscortStation.id(), GEscorts.t()) :: t()
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

  @spec build_title(GBox.id()) :: String.t()
  defp build_title(box_id) do
    case box_id do
      {_, :approach, _} -> "Approach"
      {_, :preapproach, alt} -> build_title(alt)
      {_, {:return, :evasive}, _} -> "Evasive Return"
      {_, {:return, _}, _} -> "Return"
      :notentered -> "Not Entered"
      :abovetrailing -> "Above Trailing"
      :belowtrailing -> "Below Trailing"
      id when is_atom(id) -> Atom.to_string(id) |> String.capitalize()
    end
  end

  # *** *******************************
  # *** HELPERS - GRID

  @spec grid_tailwind(GEscortStation.id() | GBox.id()) :: String.t()
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

  @spec grid_row(GBox.id()) :: integer()
  defp grid_row({_, _, altitude}) do
    [nil, :high, :level, :low]
    |> Enum.find_index(&(&1 == altitude))
  end
  defp grid_row(_), do: 0

  @spec grid_col(GBox.id()) :: integer()
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
