alias Chukinas.Geometry.{Pose, PathLike, Rect, Straight, Position, Trig, CollidableShape}
alias Chukinas.LinearAlgebra.{HasCsys, CSys}
alias Chukinas.LinearAlgebra

defmodule Straight do

  import LinearAlgebra
  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** TYPES

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

  def angle(straight), do: straight.start |> Pose.angle
  def start_pose(straight), do: straight.start
  def length(straight), do: straight.len
  def end_pose(%__MODULE__{len: len} = path) do
    path
    |> vector_new(x: len)
    |> pose_new(path.start.angle)
  end
  def bounding_rect(path) do
    [
      start_pose(path),
      end_pose(path)
    ]
    |> Rect.bounding_rect_from_positions
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
    def exceeds_angle(_straight, _angle), do: false
    def deceeds_angle(_straight, _angle), do: true
  end

  defimpl CollidableShape do
    def to_vertices(straight) do
      [
        straight |> PathLike.pose_start |> Pose.left(20),
        straight |> PathLike.pose_start |> Pose.right(20),
        straight |> PathLike.pose_end   |> Pose.right(20),
        straight |> PathLike.pose_end   |> Pose.left(20)
      ]
      |> Enum.map(&Position.to_vertex/1)
    end
  end

  defimpl HasCsys do
    def get_csys(%{start: pose}) do
      CSys.new(pose)
    end
    def get_angle(%{start: pose}) do
      Pose.angle(pose)
    end
  end
end
