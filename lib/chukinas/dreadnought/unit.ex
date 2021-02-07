defmodule Chukinas.Dreadnought.Unit do
  alias Chukinas.Dreadnought.Command
  alias Chukinas.Dreadnought.Vector
  @moduledoc """
  Represents a ship or some other combat unit
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # ID must be unique within the world
    field :id, number()

    # Vector (location and orientation)
    field :vector, Vector.t()

    # Hull and Turrets describe the physical properties of the unit.
    # field :hull, Hull.t()
    # field :turrets, [Turret.t()]

    # The deck is self-contained and has containers for cards in various states,
    # for example in-hand, discarded, and destroyed
    # field :deck, Deck.t()

    # Commands draw their data from command cards from the deck.
    # The cards' data is copied to here. Keeps a nice separation of concerns.
    field :commands, [Command.t()]
  end

  # *** *******************************
  # *** NEW

  def new() do
    start_vector = Vector.new(50, 50, 0)
    %__MODULE__{
      id: 2,
      vector: start_vector,
      commands: 1..20 |> Enum.map(&Command.new/1) |> (fn commands -> Command.set_path(commands, start_vector) end).()
      # hull: Hull.new(),
      # turrets: Turret.new(),
    }
    |> IO.inspect()
  end

end
