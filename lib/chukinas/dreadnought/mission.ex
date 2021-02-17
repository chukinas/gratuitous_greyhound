alias Chukinas.Dreadnought.{Unit, Deck, Mission}
alias Chukinas.Geometry.{Rect}

defmodule Mission do
  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :arena, Rect.t()
    field :units, [Unit.t()], default: []
    field :decks, [Deck.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new() do
    arena = Rect.new(1000, 750)
    %__MODULE__{
      arena: arena,
      units: [Unit.new(arena)],
    }
  end

end
