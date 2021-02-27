alias Chukinas.Dreadnought.{Unit, CommandQueue, Segment}
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
    # TODO this maybe should be called `number`. Here and in Segment.
    # TODO then, whenever i see number, I know it's an integet. id would mean a string like `unit--1`
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

    field :segments, [Segment.t()]
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
      segments: CommandQueue.build_segments(command_queue, start_pose, arena_rect)
    }
  end

  # *** *******************************
  # *** GETTERS

  def id(unit), do: unit.id
  def segment(unit, id) do

  end
end
