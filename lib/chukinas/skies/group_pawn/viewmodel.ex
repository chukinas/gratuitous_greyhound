defmodule Chukinas.Skies.ViewModel.GroupPawn do

  alias Chukinas.Skies.Game.FighterGroup, as: GFighterGroup

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :uiid, String.t()
    field :count, integer()
  end

  # *** *******************************
  # *** BUILD

  @spec build(GFighterGroup.t()) :: t()
  def build(g_fighter_group) do
    %__MODULE__{
      id: g_fighter_group.id,
      uiid: "pawn_group_#{g_fighter_group.id}",
      count: g_fighter_group.count,
    }
  end

end
