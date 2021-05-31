alias Chukinas.Geometry.{PathLike, Rect, CollidableShape, Circle, Trig}
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

  def new(pose, len, rotation) do
    %{
      circle: Circle.from_tangent_len_rotation(pose, len, rotation),
      traversal_angle: abs(rotation),
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
    |> Circle.location
    |> position_from_coord
    |> Rect.from_centered_square(path |> circle |> Circle.diameter)
  end

  def circle(%__MODULE__{circle: value}), do: value

  def radius(turn), do: turn |> circle |> Circle.radius

  def rotation(turn) do
    turn
    |> circle
    |> Circle.rotation_at_arclen(turn |> traversal_distance)
  end

  # *** *******************************
  # *** API

  # TODO this only works for angles smaller than that of the turn's
  def split(path, angle) do
    length0 = path |> traversal_distance
    ratio = angle / (path |> traversal_angle)
    true = ratio < 1

    pose1 = path |> pose_new
    length1 = length0 |> Trig.mult(ratio)
    rotation1 = path |> rotation |> Trig.mult(ratio)
    path1 = new(pose1, length1, rotation1)

    pose2 = Circle.tangent_pose_after_len(circle(path), length1)
    length2 = length0 - length1
    rotation2 = path |> rotation |> Trig.subtract(rotation1)
    path2 = new(pose2, length2, rotation2)

    {path1, path2}
  end

end


defimpl CollidableShape, for: Turn do
  use Chukinas.PositionOrientationSize
  def to_vertices(turn) do
    half_trav_angle = Turn.traversal_angle(turn) / 2
    {_first, second} = Turn.split(turn, half_trav_angle)
    [
      turn |> pose_new,
      second |> pose_new,
      turn |> Turn.end_pose
    ]
    |> Enum.map(&position_to_vertex/1)
  end
end


defimpl PathLike, for: Turn do
  use Chukinas.PositionOrientationSize
  def pose_start(path), do: path |> pose_new
  def pose_end(path), do: Turn.end_pose(path)
  def len(path), do: Turn.traversal_distance
  def get_bounding_rect(path), do: Turn.bounding_rect(path)
  # TODO these should end in question mark
  def exceeds_angle(turn, rotation) do
    turn |> Turn.traversal_angle > rotation
  end
  def deceeds_angle(turn, rotation) do
    turn |> Turn.traversal_angle < rotation
  end
end

