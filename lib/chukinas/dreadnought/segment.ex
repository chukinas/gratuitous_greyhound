alias Chukinas.Dreadnought.{Segment}
alias Chukinas.Svg
alias Chukinas.Geometry.{Point, Pose, Path, Position, Rect}

defmodule Segment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :start_pose, Pose.t()
    field :end_pose, Pose.t()
    field :position, Point.t()
    field :svg_path, String.t()
    field :svg_viewbox, String.t()
  end

  # *** *******************************
  # *** NEW

  def new(speed, 0 = _angle, start_pose) do
    path = Path.new_straight(start_pose, speed_to_distance(speed))
    bounding_rect = path |> Path.get_bounding_rect()
    margin = 10
    %__MODULE__{
      start_pose: Path.get_start_pose(path),
      end_pose: Path.get_end_pose(path),
      svg_viewbox: bounding_rect |> Svg.ViewBox.to_viewbox_string(start_pose, margin),
      svg_path: Svg.to_string(path),
      # TODO I don't like this...
      position: bounding_rect |> Rect.get_start_position() |> Position.subtract(margin)
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
