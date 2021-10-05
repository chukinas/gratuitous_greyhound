defmodule Dreadnought.Paths.Turn do

    use Spatial.LinearAlgebra
    use Spatial.PositionOrientationSize
    use Spatial.TypedStruct
  alias Spatial.Geometry.Circle
  alias Spatial.Geometry.Rect

  typedstruct enforce: true do
    # Fully define path:
    field :circle, Circle.t
    field :traversal_angle, number
    # Common reference values:
    pose_fields()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(pose, trav_distance, signed_trav_angle) do
    trav_angle = signed_trav_angle |> abs
    direction = Circle.rotation_direction(signed_trav_angle)
    circle =
      pose
      |> csys_from_pose
      |> Circle.from_tangent_distance_angle_direction(trav_distance, trav_angle, direction)
    %{
      circle: circle,
      traversal_angle: trav_angle,
    }
    |> merge_pose(pose)
    |> into_struct!(__MODULE__)
  end

  def connecting_path!(start_pose, end_position)
  when has_pose(start_pose)
  and has_position(end_position) do
    circle = Circle.from_tangent_and_position(start_pose, end_position)
    end_coord = end_position |> vector_from_position
    trav_angle = Circle.traversal_angle_at_coord(circle, end_coord)
    %{
      circle: circle,
      traversal_angle: trav_angle
    }
    |> merge_pose(start_pose)
    |> into_struct!(__MODULE__)
  end

  def from_circle_and_angle(circle, trav_angle) do
    start_pose =
      circle
      |> Circle.csys_after_traversing_angle(trav_angle)
      |> csys_to_pose
    %{
      circle: circle,
      traversal_angle: trav_angle
    }
    |> merge_pose(start_pose)
    |> into_struct!(__MODULE__)
  end

  # *** *******************************
  # *** CONVERTERS

  def traversal_angle(%__MODULE__{traversal_angle: value}), do: value

  def traversal_distance(turn) do
    angle = turn |> traversal_angle
    turn
    |> circle
    |> Circle.traversal_distance_after_traversing_angle(angle)
  end

  def start_pose(path), do: pose_from_map(path)

  def end_pose(path) do
    path
    |> circle
    |> Circle.csys_after_traversing_angle(path |> traversal_angle)
    |> csys_to_pose
  end

  def circle(%__MODULE__{circle: value}), do: value

  def radius(turn), do: turn |> circle |> Circle.radius

  # TODO this only works for angles smaller than that of the turn's
  def split(turn, angle) do
    trav_angle_1 = angle
    trav_angle_2 = (turn |> traversal_angle) - angle
    circle_1 = turn |> circle
    circle_2 = circle_1 |> Circle.rotate_in_direction_of_rotation(trav_angle_1)
    {
      from_circle_and_angle(circle_1, trav_angle_1),
      from_circle_and_angle(circle_2, trav_angle_2)
    }
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Dreadnought.Paths.Turn

defimpl Spatial.BoundingRect, for: Turn do
  use Spatial.LinearAlgebra
  alias Spatial.Geometry.Rect
  alias Spatial.Geometry.Circle
  def of(turn) do
    turn
    |> Turn.circle
    |> Circle.coord
    |> vector_to_position
    |> Rect.from_centered_square(turn |> Turn.circle |> Circle.diameter)
  end
end

defimpl Spatial.Collide.IsShape, for: Turn do
  use Spatial.PositionOrientationSize
  use Spatial.LinearAlgebra
  alias Spatial.Geometry.Circle
  def to_coords(turn) do
    circle = Dreadnought.Paths.Turn.circle(turn)
    trav_angle = turn |> Turn.traversal_angle
    [
      0,
      trav_angle / 2,
      trav_angle
    ]
    |> Enum.map(fn trav_angle ->
      circle
      |> Circle.coord_after_traversing_angle(trav_angle)
    end)
  end
end

defimpl Dreadnought.Paths.PathLike, for: Turn do
  use Spatial.PositionOrientationSize
  def pose_start(path), do: path |> pose_from_map
  def pose_end(path), do: Turn.end_pose(path)
  def len(path), do: Turn.traversal_distance(path)
  # TODO these should end in question mark
  def exceeds_angle(turn, rotation) do
    turn |> Turn.traversal_angle > rotation
  end
  def deceeds_angle(turn, rotation) do
    turn |> Turn.traversal_angle < rotation
  end
end
