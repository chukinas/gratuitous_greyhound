defmodule Chukinas.Skies.ViewModel.GroupPawns do

  alias Chukinas.Skies.Game.Box, as: G_Box
  alias Chukinas.Skies.Game.FighterGroups, as: G_FighterGroups
  alias Chukinas.Skies.ViewModel.GroupPawn

  # *** *******************************
  # *** TYPES

  @type t() :: [GroupPawn.t()]

  # *** *******************************
  # *** BUILD

  @spec build(G_Box.id(), G_FighterGroups.t()) :: t()
  def build(box_id, g_fighter_groups) do
    g_fighter_groups
    |> Enum.filter(fn group -> group.current_location == box_id end)
    |> Enum.map(&GroupPawn.build/1)
  end

end
