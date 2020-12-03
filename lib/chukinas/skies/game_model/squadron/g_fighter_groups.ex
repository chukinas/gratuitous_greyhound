defmodule Chukinas.Skies.Game.FighterGroups do

  alias Chukinas.Skies.Game.{Fighter, FighterGroup}

  # *** *******************************
  # *** TYPES

  @type t() :: [FighterGroup.t()]

  # *** *******************************
  # *** BUILD

  @spec build([Fighter.t()]) :: t()
  def build(fighters) do
    fighters
    |> Enum.group_by(&(&1.grouping))
    |> Map.values()
    |> Enum.map(&FighterGroup.build/1)
  end

end
