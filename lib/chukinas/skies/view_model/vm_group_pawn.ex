defmodule Chukinas.Skies.ViewModel.GroupPawn do

  alias Chukinas.Skies.Game.FighterGroup, as: G_FighterGroup

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :fighter_count,
  ]

  @type t :: %__MODULE__{
    id: String.t(),
    fighter_count: integer(),
  }


  # *** *******************************
  # *** BUILD

  @spec build(G_FighterGroup.t()) :: t()
  def build(group) do
    %__MODULE__{
      id: "pawn_group_#{group.id}",
      fighter_count: Enum.count(group.fighter_ids),
    }
  end

end
