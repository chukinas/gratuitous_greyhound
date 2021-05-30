alias Chukinas.Geometry.{PathLike, Rect, CollidableShape, Circle}
alias Chukinas.Paths.Turn

defmodule Turn do

  use Chukinas.PositionOrientationSize
  import Chukinas.LinearAlgebra
  alias Chukinas.LinearAlgebra.VectorCsys, as: V

  typedstruct enforce: true do
    pose_fields()
    field :length, number()
    # TODO replace with Circle
    # TODO make a note that rotation is a signed angle (neg for ccw)
    field :rotation, integer()
    field :radius, float()
  end

  # *** *******************************
  # *** NEW

  def new(start_pose, len, rotation) do
    %{
      length: round(len),
      rotation: rotation,
      radius: round(radius(len, rotation))
    }
    |> merge_pose(start_pose)
    |> into_struct!(__MODULE__)
  end

  # TODO remove if unused
  def new(x, y, orientation, len, rotation) do
    new pose_new(x, y, orientation), len, rotation
  end

  # *** *******************************
  # *** GETTERS

  def start_pose(path), do: path.pose
  def end_pose(path) do
    {radius, rotation} = radius_and_rotation(path)
    path
    |> V.new
    |> V.rotate_90(rotation)
    |> V.forward(radius)
    |> V.rotate(180 + rotation)
    |> V.forward(radius)
    |> V.rotate_90(rotation)
    |> V.pose
  end
  def bounding_rect(path) do
    path
    |> end_pose
    |> position_new
    |> position_min_max(path)
    |> Rect.new
  end

  def center_vector(%__MODULE__{} = turn) do
    {radius, rotation} = radius_and_rotation(turn)
    vector_90(turn, radius, rotation)
  end

  def radius(%__MODULE__{radius: value}), do: value

  def rotation(%__MODULE__{rotation: value}), do: value

  def radius_and_rotation(%__MODULE__{rotation: rot, radius: rad}), do: {rad, rot}

  # *** *******************************
  # *** API

  def get_radius(path), do: path.radius

  def split(%__MODULE__{rotation: angle_orig} = path, angle) when abs(angle_orig) > abs(angle) do
    ratio = angle / angle_orig
    path1 = new(
      path,
      len1 = (path.length * ratio),
      angle
    )
    path2 = new(
      PathLike.pose_end(path1),
      path.length - len1,
      angle_orig - angle
    )
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

  defp radius(length, rotation) do
    (length * 360) / (2 * :math.pi() * abs(rotation))
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl PathLike do
    def pose_start(path), do: path |> pose
    def pose_end(path), do: Turn.end_pose(path)
    def len(path), do: path.length
    def get_bounding_rect(path), do: Turn.bounding_rect(path)
    # TODO these should end in question mark
    def exceeds_angle(turn, rotation), do: abs(turn.rotation) > abs(rotation)
    def deceeds_angle(turn, rotation), do: abs(turn.rotation) < abs(rotation)
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

