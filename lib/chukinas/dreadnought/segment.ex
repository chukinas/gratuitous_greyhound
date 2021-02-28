alias Chukinas.Dreadnought.{Segment}
alias Chukinas.Svg
alias Chukinas.Geometry.{Pose, Path}

defmodule Segment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :unit_id, integer()
    # TODO this really ought to be called soething like number or segment_number
    # TODO there need to be two ids really, for both the segment num and unit id
    field :id, integer()
    field :start_pose, Pose.t()
    field :end_pose, Pose.t()
    field :svg_path, String.t()
  end

  # *** *******************************
  # *** NEW

  def new(path, unit_id, segment_number) do
    %__MODULE__{
      unit_id: unit_id,
      id: segment_number,
      start_pose: Path.get_start_pose(path),
      end_pose: Path.get_end_pose(path),
      svg_path: Svg.get_path_string(path),
    }
  end

  # *** *******************************
  # *** GETTERS

  # TODO these should replace the get_* below
  def start_pose(segment), do: segment.start_pose
  def end_pose(segment), do: segment.end_pose
  def svg_path(segment), do: segment.svg_path

  # *** *******************************
  # *** API

  def get_start_pose(segment) do
    segment.start_pose
  end

  def get_end_pose(segment) do
    segment.end_pose
  end

  # TODO no longer belongs here?
  def speed_to_distance(speed) when is_integer(speed) do
    %{
      1 => 50,
      2 => 75,
      3 => 100,
      4 => 150,
      5 => 200
    } |> Map.fetch!(speed)
  end

end
