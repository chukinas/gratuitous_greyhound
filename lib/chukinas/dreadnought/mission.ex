alias Chukinas.Dreadnought.{Unit, Deck, Mission, Guards}
alias Chukinas.Geometry.{Rect}

defmodule Mission do
  import Guards

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

  # *** *******************************
  # *** GETTERS

  def unit(mission, id), do: get_by_id(mission.units, id)
  def deck(mission, id), do: get_by_id(mission.decks, id)

  # *** *******************************
  # *** API

  def issue_command(mission, opts) when is_list(opts), do: issue_command(mission, Map.new(opts))
  def issue_command(mission, opts) do
    # find card in hand and remove it from hand
    # extraxt command from the card
    # put card in discard pile
    # draw back up to hand size
    :noop
  end
end
