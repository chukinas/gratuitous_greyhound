defmodule Chukinas.Skies.Game.TacticalPoints do
  alias Chukinas.Skies.Game.{Fighter, Squadron}

  @type t :: %{
    starting: integer(),
    spent: integer(),
  }

  def new() do
    %{
      starting: 1,
      spent: 0,
    }
  end

  def calculate(%{spent: spent} = tp, squadron) do
    spent = spent + case Squadron.any_fighters?(
      squadron,
      &Fighter.delayed_entry?/1
    ) do
      true -> 1
      false -> 0
    end
    %{tp | spent: spent}
  end

end
