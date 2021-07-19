defmodule Chukinas.Paths.Straight do

  import Chukinas.LinearAlgebra
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  alias Chukinas.Collide
  alias Chukinas.Geometry.Rect
  alias Chukinas.LinearAlgebra.HasCsys
  alias Chukinas.Paths.PathLike
  alias Chukinas.Paths.Straight

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    pose_fields()
    field :len, number()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(start_pose, len) do
    %{len: len}
    |> merge_pose(start_pose)
    |> into_struct!(__MODULE__)
  end

  def new(x, y, angle, len), do: new(pose(x, y, angle), len)

  # *** *******************************
  # *** CONVERTERS

  def angle(straight), do: straight |> get_angle
  def start_pose(straight), do: straight |> pose_new
  def length(straight), do: straight.len
  def end_pose(%__MODULE__{len: len} = path) do
    path
    |> csys_from_pose
    |> csys_translate({:forward, len})
    |> csys_to_pose
  end
  def bounding_rect(path) do
    Rect.from_positions(
      start_pose(path),
      end_pose(path)
    )
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
      |> vector_to_magnitude
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

  defimpl Collide.IsShape do
    def to_coords(straight) do
      end_pose = PathLike.pose_end(straight)
      coord_vector = fn pose, angle ->
        pose
        |> csys_from_pose
        |> csys_rotate(angle)
        |> csys_translate_forward(20)
        |> csys_to_coord_vector
      end
      [
        coord_vector.(straight, :left),
        coord_vector.(straight, :right),
        coord_vector.(end_pose, :right),
        coord_vector.(end_pose, :left)
      ]
    end
  end

  defimpl HasCsys do

    def get_csys(%{start: pose}) do
      csys_from_pose(pose)
    end

    def get_angle(%{angle: value}), do: value

  end
end
