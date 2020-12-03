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
    }
  end

end
