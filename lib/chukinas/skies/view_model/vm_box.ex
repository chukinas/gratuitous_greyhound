defmodule Chukinas.Skies.ViewModel.Box do

  alias Chukinas.Skies.Game.FighterGroups, as: G_FighterGroups
  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.ViewModel.GroupPawn

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :title, String.t()
    field :id, String.t()
    field :pawns, [GroupPawn.t()]
    field :grid_tailwind, String.t()
    # TODO
    # field :row, integer()
    # field :col, integer()
  end

  # *** *******************************
  # *** BUILD

  @spec build(G_Box.t(), G_FighterGroups.t()) :: t()
  def build(box, all_groups) do
    group_pawns = all_groups
    |> Enum.filter(fn group -> group.current_location == box.id end)
    |> Enum.map(&GroupPawn.build/1)
    id = box.id |> G_Box.id_to_string()
    %__MODULE__{
      title: id,
      id: id,
      pawns: group_pawns,
      grid_tailwind: grid_tailwind(box.id)
      # TODO
      # row: grid_row(box.id),
      # col: grid_col(box.id),
    }
  end

  # *** *******************************
  # *** HELPERS

  @spec grid_tailwind(G_Box.id()) :: String.t()
  def grid_tailwind(g_box) do
    [
      "row-start-#{grid_row(g_box)}",
      "col-start-#{grid_col(g_box)}",
    ]
    |> Enum.join(" ")
  end

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
