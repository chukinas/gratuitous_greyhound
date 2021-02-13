alias Chukinas.Dreadnought.{Command, Vector, Svg, MoveSegment}

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

  def new(segment_number) do
    %__MODULE__{
      segment_number: segment_number,
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

  # *** *******************************
  # *** PRIVATE

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
