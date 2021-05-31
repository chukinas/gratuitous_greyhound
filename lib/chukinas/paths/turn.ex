alias Chukinas.Geometry.{PathLike, Rect, CollidableShape, Circle, Trig}
alias Chukinas.Paths.Turn

defmodule Turn do

  use Chukinas.PositionOrientationSize

  typedstruct enforce: true do
    pose_fields()
    field :circle, Circle.t
    field :length, number
    # Readonly reference fields
    field :rotation, number
  end

  # *** *******************************
  # *** NEW

  def new(pose, len, rotation) do
    %{
      circle: Circle.from_tangent_len_rotation(pose, len, rotation),
      length: len,
      rotation: rotation
    }
    |> merge_pose(pose)
    |> into_struct!(__MODULE__)
  end

  #def new(x, y, orientation, len, rotation) do
  #  new pose_new(x, y, orientation), len, rotation
  #end

  # *** *******************************
  # *** GETTERS

  def start_pose(path), do: path.pose
  def end_pose(path) do
    path
    |> circle
    |> Circle.tangent_pose_after_len(path.length)
  end
  def bounding_rect(path) do
    path
    |> end_pose
    |> position_new
    |> position_min_max(path)
    |> Rect.new
  end

  #def center_vector(%__MODULE__{} = turn) do
  #end

  def circle(%__MODULE__{circle: value}), do: value

  def radius(turn), do: turn |> circle |> Circle.radius

  def rotation(turn) do
    turn
    |> circle
    |> Circle.rotation_at_arclen(turn |> length)
  end

  # *** *******************************
  # *** API

  # def get_radius(path), do: path.radius

  # TODO this only works for angles smaller than that of the turn's
  def split(path, angle) do
    length0 = path |> length
    ratio = angle / (path |> angle)
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

  def connecting_path!(start_pose, end_position)
  when has_pose(start_pose)
  and has_position(end_position) do
    circle = Circle.from_tangent_and_position(start_pose, end_position)
    rotation = Circle.rotation_at(circle, end_position)
    len = Circle.arc_len_at_angle(circle, rotation)
    new(start_pose, len, rotation)
  end

  # *** *******************************
  # *** PRIVATE

  #defp radius(length, rotation) do
  #  (length * 360) / (2 * :math.pi() * abs(rotation))
  #end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl PathLike do
    def pose_start(path), do: path |> pose
    def pose_end(path), do: Turn.end_pose(path)
    def len(path), do: path.length
    def get_bounding_rect(path), do: Turn.bounding_rect(path)
    # TODO these should end in question mark
    def exceeds_angle(_turn, _rotation) do
      raise "woops"
    end
    def deceeds_angle(_turn, _rotation) do
      raise "woops"
    end
  end

  defimpl CollidableShape do
    def to_vertices(turn) do
      {_first, second} = turn |> Turn.split(turn.rotation/2)
      [
        turn |> pose,
        second |> pose,
        turn |> Turn.end_pose
      ]
      |> Enum.map(&position_to_vertex/1)
    end
  end
end

