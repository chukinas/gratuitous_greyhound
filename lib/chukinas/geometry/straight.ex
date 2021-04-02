alias Chukinas.Geometry.{Polar, Pose, PathLike, Rect, Straight, Position, Trig}

defmodule Straight do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :start, Pose.t()
    field :len, number()
  end

  # *** *******************************
  # *** NEW

  def new(start_pose, len) do
    %__MODULE__{
      start: start_pose,
      len: len,
    }
  end
  def new(x, y, angle, len) do
    %__MODULE__{
      start: Pose.new(x, y, angle),
      len: len,
    }
  end

  # *** *******************************
  # *** GETTERS

  def start_pose(straight), do: straight.start
  def length(straight), do: straight.len
  def end_pose(path) do
    %{x: x0, y: y0, angle: angle} = start_pose(path)
    %{x: dx, y: dy} = Polar.new(path.len, angle)
    |> Polar.to_cartesian()
    Pose.new(x0 + dx, y0 + dy, angle)
  end
  def bounding_rect(path) do
    start = path |> start_pose()
    final = path |> end_pose()
    {xmin, xmax} = Enum.min_max([start.x, final.x])
    {ymin, ymax} = Enum.min_max([start.y, final.y])
    Rect.new(xmin, ymin, xmax, ymax)
  end

  # *** *******************************
  # *** API

  @doc"""
  Returns a straight path if end_position lies upon path in front of start_pose.
  Otherwise, returns nil.
  """
  def get_connecting_path(start_pose, end_position) do
    # Calculate the angle b/w start and end position.
    # Then compare that to the actual start angle to see if there's a match.
    distance = Trig.distance_between_points start_pose, end_position
    proposed_path = new(start_pose, distance)
    if proposed_path |> end_pose |> Position.approx_equal(end_position) do
      proposed_path
    else
      nil
    end
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl PathLike do
    def pose_start(path), do: Straight.start_pose(path)
    def pose_end(path), do: Straight.end_pose(path)
    def len(path), do: Straight.length(path)
    def get_bounding_rect(path), do: Straight.bounding_rect(path)
  end
end
