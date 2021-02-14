alias Chukinas.Dreadnought.{Command, Vector, Svg, MoveSegment}
alias Chukinas.Geometry.{Path, Pose, Position, Rect}
# TODO remove refs to the old svg
alias Chukinas.Svg, as: SvgNew

defmodule Command do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # TODO keep
    field :speed, integer(), default: 3
    field :angle, integer(), default: 0
    field :segment_number, integer(), enforce: false
    field :segment_count, integer(), default: 1
    field :type, atom(), default: :default
    field :vector_start, Vector.t(), enforce: false
    # TODO remove (this will be captured by Routes)
    field :vector_end, Vector.t(), enforce: false
    field :svg_path, String.t(), enforce: false
    field :viewbox, String.t(), enforce: false
  end

  # *** *******************************
  # *** NEW

  def new(_opts \\ []) do
    %__MODULE__{
    }
  end

  # *** *******************************
  # *** API

  def set_path(%__MODULE__{angle: 0, speed: speed} = command, %Vector{} = start_vector) do
    vector_end = Vector.move_straight(start_vector, speed_to_distance(speed))
    command
    |> Map.put(:vector_start, start_vector)
    |> Map.put(:vector_end, vector_end)
    |> Map.put(:svg_path, Svg.relative_line(vector_end.point))
  end

  # TODO make note about how segments are listed from later (future) to oldest (past)
  def get_segment_numbers(%__MODULE__{segment_number: min_segment} = command) do
    max_segment = min_segment + command.segment_count - 1
    min_segment..max_segment
  end

  def occupies_segment(%__MODULE__{} = command, segment_number) do
    segment_number in get_segment_numbers(command)
  end

  def get_move_segments(command, previous_segments) when is_list(previous_segments) do
    start_pose = previous_segments |> List.last() |> MoveSegment.get_end_pose()
    get_move_segments(command, start_pose)
  end
  def get_move_segments(%__MODULE__{segment_count: 1} = command, %Pose{} = start_pose) do
    path = Path.new_straight(start_pose, speed_to_distance(command.speed))
    bounding_rect = path |> Path.get_bounding_rect()
    margin = 10
    move_segment = %MoveSegment{
      # TODO should this constructor be moved out into a `new` fun in MoveSeg?
      start_pose: Path.get_start_pose(path),
      end_pose: Path.get_end_pose(path),
      svg_viewbox: bounding_rect |> SvgNew.ViewBox.to_viewbox_string(start_pose, margin),
      svg_path: SvgNew.to_string(path),
      # TODO I don't like this...
      position: bounding_rect |> Rect.get_start_position() |> Position.subtract(margin)
    }
    [move_segment]
  end

  # *** *******************************
  # *** PRIVATE

  # TODO rename speed to length?
  defp speed_to_distance(speed) when is_integer(speed) do
    %{
      1 => 50,
      2 => 75,
      3 => 100,
      4 => 150,
      5 => 200
    } |> Map.fetch!(speed)
  end

end
