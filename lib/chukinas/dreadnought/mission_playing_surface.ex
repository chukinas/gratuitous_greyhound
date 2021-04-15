alias Chukinas.Dreadnought.{Mission.PlayingSurface}

defmodule PlayingSurface do
  @moduledoc """
  The game's playing surface, with islands, border, etc
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :world, Size.t()
    field :margin, Size.t()
    field :islands, [Island.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(%{
    world: world,
    margin: margin,
    islands: islands
  }) do
    %__MODULE__{
      world: world,
      margin: margin,
      islands: islands
    }
  end
end
