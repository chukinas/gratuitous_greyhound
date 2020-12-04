defmodule Chukinas.Skies.Game.Escorts do

  alias Chukinas.Skies.Game.Escort

  # *** *******************************
  # *** TYPES

  @type t() :: [Escort.t()]

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    []
  end

end
