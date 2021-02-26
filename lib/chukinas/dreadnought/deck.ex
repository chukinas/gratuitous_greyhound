alias Chukinas.Dreadnought.{Card, Deck}
defmodule Deck do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :id, integer(), enforce: true

    # Player draws from this stack into hand:
    field :draw_pile, [Card.t()], default: []

    # Cards immediately available to player, on screen
    field :hand, [Card.t()], default: []

    # Cards currently assigned to its unit's path
    field :path, [Card.t()], default: []

    # Cards that have discarded, awaiting shuffle and add to draw pile
    field :discard_pile, [Card.t()], default: []

    # Destroyed cards are out of the game, never to return.
    field :destroyed, [Card.t()], default: []
  end

  # *** *******************************
  # *** NEW

  @spec new(integer()) :: t()
  def new(id) do
    %__MODULE__{
      id: id,
      draw_pile: Enum.map(1..30, &Card.new(&1, id))
    }
  end

  # *** *******************************
  # *** DRAW

  @spec draw(t(), integer()) :: t()
  def draw(deck, 1) do
    draw(deck)
  end
  def draw(deck, card_count) do
    new_deck = draw(deck)
    draw(new_deck, card_count - 1)
  end

  @spec draw(t()) :: t()
  def draw(%__MODULE__{draw_pile: [], discard_pile: []} = deck) do
    # There are no draw or discard piles to draw from, so no draw!
    deck
  end
  def draw(%__MODULE__{draw_pile: []} = deck) do
    deck
    |> Map.put(:draw_pile, Enum.shuffle(deck.discard_pile))
    |> Map.put(:discard_pile, [])
    |> draw
  end
  def draw(deck) do
    [drawn_card | draw_pile] = deck.draw_pile
    %{deck | draw_pile: draw_pile, hand: [drawn_card | deck.hand]}
  end

end
