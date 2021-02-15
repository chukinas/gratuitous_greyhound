alias Chukinas.Dreadnought.{Command, Segment}
alias Chukinas.Geometry.{Pose}

defmodule Command do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :speed, integer(), default: 3
    field :angle, integer(), default: 0
    field :segment_number, integer(), enforce: false
    field :segment_count, integer(), default: 1
    field :type, atom(), default: :default
  end

  # *** *******************************
  # *** NEW

  def new(_opts \\ []) do
    %__MODULE__{
    }
  end

  # *** *******************************
  # *** API

  # TODO make note about how segments are listed from later (future) to oldest (past)
  def get_segment_numbers(%__MODULE__{segment_number: min_segment} = command) do
    max_segment = min_segment + command.segment_count - 1
    min_segment..max_segment
  end

  def occupies_segment(%__MODULE__{} = command, segment_number) do
    segment_number in get_segment_numbers(command)
  end

  def get_move_segments(command, previous_segments) when is_list(previous_segments) do
    start_pose = previous_segments |> List.last() |> Segment.get_end_pose()
    get_move_segments(command, start_pose)
  end
  def get_move_segments(%__MODULE__{segment_count: 1} = command, %Pose{} = start_pose) do
    [Segment.new(command.speed, command.angle, start_pose, command.segment_number)]
  end

end
