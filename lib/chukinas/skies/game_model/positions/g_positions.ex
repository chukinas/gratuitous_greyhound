defmodule Chukinas.Skies.Game.Positions do

  alias Chukinas.Skies.Game.Position
  alias Chukinas.Skies.Game.Boxes, as: NewPositions

  # *** *******************************
  # *** TYPES

  @type t :: [Position.t()]

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    NewPositions.build()
  end

  # *** *******************************
  # *** API


end
