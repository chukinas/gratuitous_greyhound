defmodule Chukinas.Skies.Game.TacticalPoints do

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

end
