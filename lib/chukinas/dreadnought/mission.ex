alias Chukinas.Dreadnought.{Unit, Deck, Mission}
alias Chukinas.Geometry.{Rect}

defmodule Mission do
  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :state, atom(), default: :pregame
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
      # TODO need to pass in the unit number here as well
      units: [Unit.new(arena)],
      decks: [Deck.new(2)]
    }
  end

  def issue_command(_unit_num, _card_num, _seg_num) do
    # find card in hand and remove it from hand
    # extraxt command from the card
    # put card in discard pile
    # draw back up to hand size
    :noop
  end
end
