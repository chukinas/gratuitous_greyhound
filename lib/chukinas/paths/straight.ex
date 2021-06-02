alias Chukinas.Geometry.{Rect, CollidableShape}
alias Chukinas.LinearAlgebra.{HasCsys, CSys}
alias Chukinas.LinearAlgebra
alias Chukinas.Paths.{Straight, PathLike}

defmodule Straight do

  import LinearAlgebra
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  import Chukinas.Collide

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    pose_fields()
    field :len, number()
  end

  # *** *******************************
  # *** NEW

  def new(start_pose, len) do
    %{len: len}
    |> merge_pose(start_pose)
    |> into_struct!(__MODULE__)
  end

  def new(x, y, angle, len), do: new(pose(x, y, angle), len)

  # *** *******************************
  # *** GETTERS

  def angle(straight), do: straight |> get_angle
  def start_pose(straight), do: straight |> pose_new
  def length(straight), do: straight.len
  def end_pose(%__MODULE__{len: len} = path) do
    path
    |> vector_forward(len)
    |> position_new
    |> merge_position_into!(path)
    |> pose_new
  end
  def bounding_rect(path) do
    {
      start_pose(path),
      end_pose(path)
    }
    |> Rect.new
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
    distance =
      end_position
      |> position_subtract(start_pose)
      |> vector_from_position
      |> magnitude_from_vector
    proposed_path = new(start_pose, distance)
    if proposed_path |> end_pose |> position_new |> approx_equal(end_position) do
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
      end_pose = PathLike.pose_end(straight)
      for vector <- [
        straight |> vector_left(20),
        straight |> vector_right(20),
        end_pose |> vector_right(20),
        end_pose |> vector_left(20)
      ], do: vertex_new(vector)
    end
  end

  defimpl HasCsys do

    def get_csys(%{start: pose}) do
      CSys.new(pose)
    end

    def get_angle(%{angle: value}), do: value

  end
end
