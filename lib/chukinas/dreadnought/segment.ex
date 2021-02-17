alias Chukinas.Dreadnought.{Segment}
alias Chukinas.Svg
alias Chukinas.Geometry.{Pose, Path}

defmodule Segment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # TODO I don't think this number is being set properly
    field :segment_number, integer()
    field :start_pose, Pose.t()
    field :end_pose, Pose.t()
    field :svg_path, String.t()
  end

  # *** *******************************
  # *** NEW

  def new(speed, 0 = _angle, start_pose, segment_number) do
    path = Path.new_straight(start_pose, speed_to_distance(speed))
    %__MODULE__{
      segment_number: segment_number,
      start_pose: Path.get_start_pose(path),
      end_pose: Path.get_end_pose(path),
      svg_path: Svg.get_path_string(path),
    }
  end

  # *** *******************************
  # *** API

  def get_start_pose(segment) do
    segment.start_pose
  end

  def get_end_pose(segment) do
    segment.end_pose
  end

  # *** *******************************
  # *** PRIVATE

  # TODO move this to a config file
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
