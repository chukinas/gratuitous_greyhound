alias Chukinas.Dreadnought.{Unit, Mission, Guards, CommandQueue, Segment, CommandIds}
alias Chukinas.Geometry.{Rect, Pose}

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
    field :segments, [Segment.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new() do
    command_queue = CommandQueue.new(2)
    start_pose = Pose.new(0, 200, 30)
    mission = %__MODULE__{
      arena: Rect.new(1000, 750),
      # TODO need to pass in the unit number here as well
      # TODO refactor so that I can pass 1 in here instead of 2
      units: [Unit.new(2)],
      decks: [command_queue]
    }
    segments = CommandQueue.build_segments(command_queue, start_pose, mission.arena)
    %{mission | segments: segments}
  end

  # *** *******************************
  # *** GETTERS

  def unit(%__MODULE__{} = mission, %CommandIds{unit: id}), do: unit(mission, id)
  def unit(%__MODULE__{} = mission, id), do: get_by_id(mission.units, id)
  def get_unit(%__MODULE__{} = mission, id), do: unit(mission, id)

  def deck(%__MODULE__{} = mission, %CommandIds{unit: id}), do: deck(mission, id)
  def deck(%__MODULE__{} = mission, id), do: get_by_id(mission.decks, id)
  def get_deck(%__MODULE__{} = mission, id), do: deck(mission, id)
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

  def issue_command(%__MODULE__{} = mission, %CommandIds{} = cmd) do
    {played_card, deck} =
      get_deck(mission, cmd)
      |> CommandQueue.play_card(cmd)
    # find card in hand and remove it from hand
    # extraxt command from the card
    # put card in discard pile
    # draw back up to hand size
    :noop
  end

  # *** *******************************
  # *** PRIVATE

  # defp update_unit_segments(%__MODULE__{} = mission) do
  #   unit_ids =
  #     mission.decks
  #     |> Enum.map(&CommandQueue.get_id/1)
  #   update_unit_segments(mission, unit_ids)
  # end

  # defp update_unit_segments(%__MODULE__{} = mission, [id]) do
  #   update_unit_segments(mission, id)
  # end

  # defp update_unit_segments(%__MODULE__{} = mission, [id | remaining_ids]) do
  #   update_unit_segments(mission, id)
  #   |> update_unit_segments(remaining_ids)
  # end

  # defp update_unit_segments(%__MODULE__{} = mission, unit_id) when is_integer(unit_id) do
  #   deck = get_deck mission, unit_id
  #   unit = get_unit(mission, unit_id)
  #   start_pose = unit |> Unit.start_pose()
  #   arena = mission.arena
  #   segments = CommandQueue.build_segments deck, start_pose, arena
  #   unit = Unit.set_segments(unit, segments)
  #   push(mission, unit)
  # end
end
