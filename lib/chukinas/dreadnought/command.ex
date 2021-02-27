alias Chukinas.Dreadnought.{Command, Segment}
alias Chukinas.Geometry.{Pose, Path}

defmodule Command do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    # 1..5
    # Each speed rating transforms into a distance travelled.
    field :speed, integer(), default: 3
    # Angle of turn
    # 0 for straight maneuver
    # X  for right turn (e.g. 45)
    # -X for left turn (e.g. -45)
    field :angle, integer(), default: 0
    field :segment_number, integer(), enforce: false
    field :segment_count, integer(), default: 1
  end

  # *** *******************************
  # *** NEW

  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def random() do
    fields =
      [
        speed: Enum.random(1..5),
        angle: -18..18 |> Enum.map(&(&1 * 5)) |> Enum.random()
      ]
    struct(__MODULE__, fields)
  end

  # *** *******************************
  # *** API

  def generate_segments(command, previous_segments) when is_list(previous_segments) do
    start_pose = previous_segments |> List.last() |> Segment.get_end_pose()
    generate_segments(command, start_pose)
  end
  def generate_segments(%__MODULE__{segment_count: 1} = command, %Pose{} = start_pose) do
    len = Segment.speed_to_distance(command.speed)
    path = case command.angle do
      0 -> Path.new_straight(start_pose, len)
      angle -> Path.new_turn(start_pose, len, angle)
    end
    [Segment.new(path, command.segment_number)]
  end

  def set_segment_number(command, segment_number) do
    Map.put(command, :segment_number, segment_number)
  end
end
