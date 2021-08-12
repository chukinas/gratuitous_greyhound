defmodule Dreadnought.Paths.Straight do

  import Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize
  use Dreadnought.LinearAlgebra
  alias Dreadnought.Geometry.Rect
  alias Dreadnought.Paths.Straight

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

  def new(x, y, angle, len), do: new(pose_new(x, y, angle), len)

  # *** *******************************
  # *** CONVERTERS

  def angle(straight), do: straight |> get_angle

  def end_pose(%__MODULE__{len: len} = path) do
    path
    |> csys_from_pose
    |> csys_translate({:forward, len})
    |> csys_to_pose
  end

  def length(straight), do: straight.len

  def start_pose(straight), do: straight |> pose_from_map

  # *** *******************************
  # *** BOUNDARY

  @doc"""
  Returns a straight path if end_position lies upon path in front of start_pose.
  Otherwise, returns :error.
  """
  def fetch_connecting_path(start_pose, end_position) do
    # Calculate the angle b/w start and end position.
    # Then compare that to the actual start angle to see if there's a match.
    distance =
      end_position
      |> position_subtract(start_pose)
      |> vector_from_position
      |> vector_to_magnitude
    proposed_path = new(start_pose, distance)
    if proposed_path |> end_pose |> position_new |> approx_equal(end_position) do
      {:ok, proposed_path}
    else
      :error
    end
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Dreadnought.Paths.PathLike
alias Dreadnought.Paths.Straight

defimpl PathLike, for: Straight do
  def pose_start(path), do: Straight.start_pose(path)
  def pose_end(path), do: Straight.end_pose(path)
  def len(path), do: Straight.length(path)
  def exceeds_angle(_straight, _angle), do: false
  def deceeds_angle(_straight, _angle), do: true
end

defimpl Dreadnought.BoundingRect, for: Straight do
  alias Dreadnought.Geometry.Rect
  def of(path) do
    Rect.from_positions(
      Straight.start_pose(path),
      Straight.end_pose(path)
    )
  end
end

defimpl Dreadnought.Collide.IsShape, for: Straight do
  use Dreadnought.LinearAlgebra
  use Dreadnought.PositionOrientationSize
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

defimpl Dreadnought.LinearAlgebra.HasCsys, for: Straight do
  use Dreadnought.LinearAlgebra
  def get_angle(%{angle: value}), do: value
  def get_csys(%{start: pose}), do: csys_from_pose(pose)
end

