defmodule Chukinas.Skies.Game.Positions do
  # TODO delete module

  alias Chukinas.Skies.Game.{Position, Boxes}

  # *** *******************************
  # *** TYPES

  @type t :: [Position.t()]

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    Boxes.new()
  end

  # *** *******************************
  # *** API


end
