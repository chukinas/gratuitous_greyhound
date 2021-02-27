alias Chukinas.Dreadnought.{Unit, Mission, Guards, CommandQueue}
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
    field :decks, [CommandQueue.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new() do
    arena = Rect.new(1000, 750)
    %__MODULE__{
      arena: arena,
      # TODO need to pass in the unit number here as well
      units: [Unit.new(arena)],
      decks: [CommandQueue.new(2)]
    }
  end

  # *** *******************************
  # *** GETTERS

  def unit(mission, %{unit: id}), do: unit(mission, id)
  def unit(mission, id), do: get_by_id(mission.units, id)
  def get_unit(mission, id), do: unit(mission, id)

  def deck(mission, %{unit: id}), do: deck(mission, id)
  def deck(mission, id), do: get_by_id(mission.decks, id)
  def get_deck(mission, id), do: deck(mission, id)
  # TODO which syntax to use?

  # *** *******************************
  # *** SETTERS

  def push(%__MODULE__{units: units} = mission, %Unit{} = unit) do
    %{mission | units: replace_by_id(units, unit)}
  end
  def push(%__MODULE__{decks: decks} = mission, %CommandQueue{} = deck) do
    %{mission | decks: replace_by_id(decks, deck)}
  end

  # *** *******************************
  # *** API

  def issue_command(mission, cmd) do
    {played_card, deck} =
      get_deck(mission, cmd)
      |> CommandQueue.play_card(cmd)
    # find card in hand and remove it from hand
    # extraxt command from the card
    # put card in discard pile
    # draw back up to hand size
    :noop
  end
end
