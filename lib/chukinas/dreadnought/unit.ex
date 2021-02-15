alias Chukinas.Dreadnought.{Unit, CommandQueue, Segments}
alias Chukinas.Geometry.{Pose}

defmodule Unit do
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
    field :start_pose, Pose.t()

    # Hull and Turrets describe the physical properties of the unit.
    # field :hull, Hull.t()
    # field :turrets, [Turret.t()]

    # The deck is self-contained and has containers for cards in various states,
    # for example in-hand, discarded, and destroyed
    # field :deck, Deck.t()

    # Commands draw their data from command cards from the deck.
    # The cards' data is copied to here. Keeps a nice separation of concerns.
    field :command_queue, CommandQueue.t()

    field :segments, Segments.t()
  end

  # *** *******************************
  # *** NEW

  def new(arena_rect) do
    start_pose = Pose.new(0, 0, 45)
    command_queue = CommandQueue.new()
    %__MODULE__{
      id: 2,
      start_pose: start_pose,
      command_queue: command_queue,
      segments: Segments.init(command_queue, start_pose, arena_rect)
    }
  end

end
