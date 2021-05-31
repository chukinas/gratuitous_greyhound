alias Chukinas.Geometry.{PathLike, Rect, CollidableShape, Circle}
alias Chukinas.Paths.Turn

defmodule Turn do

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra

  typedstruct enforce: true do
    # Fully define path:
    field :circle, Circle.t
    field :traversal_angle, number
    # Common reference values:
    pose_fields()
  end

  # *** *******************************
  # *** NEW

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
    end_coord = end_position |> coord_from_position
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
      |> pose_from_csys
    %{
      circle: circle,
      traversal_angle: trav_angle
    }
    |> merge_pose(start_pose)
    |> into_struct!(__MODULE__)
  end

  # *** *******************************
  # *** GETTERS

  def traversal_angle(%__MODULE__{traversal_angle: value}), do: value

  def traversal_distance(turn) do
    angle = turn |> traversal_angle
    turn
    |> circle
    |> Circle.traversal_distance_after_traversing_angle(angle)
  end

  def start_pose(path), do: pose_new(path)

  def end_pose(path) do
    path
    |> circle
    |> Circle.csys_after_traversing_angle(path |> traversal_angle)
    |> pose_from_csys
  end

  # TODO remove
  def bounding_rect(path) do
    path
    |> circle
    # TODO alias Circle, don't import
    # TODO rename Circle.coord
    |> Circle.coord
    |> position_from_coord
    |> Rect.from_centered_square(path |> circle |> Circle.diameter)
  end

  def circle(%__MODULE__{circle: value}), do: value

  def radius(turn), do: turn |> circle |> Circle.radius

  # *** *******************************
  # *** API

  # TODO this only works for angles smaller than that of the turn's
  def split(path, angle) do
    trav_angle_1 = angle
    trav_angle_2 = (path |> traversal_angle) - angle
    circle_1 = path |> circle
    circle_2 = circle_1 |> Circle.rotate_in_direction_of_rotation(trav_angle_1)
    {
      from_circle_and_angle(circle_1, trav_angle_1),
      from_circle_and_angle(circle_2, trav_angle_2)
    }
  end

end


defimpl CollidableShape, for: Turn do
  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra
  def to_vertices(turn) do
    circle = Turn.circle(turn)
    trav_angle = turn |> Turn.traversal_angle
    [
      0,
      trav_angle / 2,
      trav_angle
    ]
    |> Enum.map(fn trav_angle ->
      circle
      |> Circle.coord_after_traversing_angle(trav_angle)
      |> position_from_coord
    end)
    |> Enum.map(&position_to_vertex/1)
  end
end


defimpl PathLike, for: Turn do
  use Chukinas.PositionOrientationSize
  def pose_start(path), do: path |> pose_new
  def pose_end(path), do: Turn.end_pose(path)
  def len(path), do: Turn.traversal_distance(path)
  def get_bounding_rect(path), do: Turn.bounding_rect(path)
  # TODO these should end in question mark
  def exceeds_angle(turn, rotation) do
    turn |> Turn.traversal_angle > rotation
  end
  def deceeds_angle(turn, rotation) do
    turn |> Turn.traversal_angle < rotation
  end
end

