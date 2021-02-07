defmodule Chukinas.Dreadnought.Mission do
  alias Chukinas.Dreadnought.Unit
  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :size_x, integer()
    field :size_y, integer()
    # field :terrain, [Terrain.t()]
    # field :start_areas, [StartArea.t()]
    field :units, [Unit.t()], default: []
    field :decks, [Deck.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new() do
    %__MODULE__{
      size_x: 1000,
      size_y: 750,
      units: [Unit.new()],
    }
  end

end
