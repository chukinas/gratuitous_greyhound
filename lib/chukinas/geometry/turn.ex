alias Chukinas.Geometry.{Pose, Position, PathLike, Rect, Straight, Turn}

defmodule Turn do

  use TypedStruct

  typedstruct enforce: true do
    field :pose, Pose.t()
    field :length, number()
    field :angle, integer()
    field :radius, float()
  end

  # *** *******************************
  # *** NEW

  def new(%Pose{} = start_pose, len, angle) do
    %__MODULE__{
      pose: start_pose,
      length: len,
      angle: angle,
      radius: radius(len, angle)
    }
  end
  def new(x, y, angle, len, angle) do
    new Pose.new(x, y, angle), len, angle
  end

  # *** *******************************
  # *** GETTERS

  def start_pose(path), do: path.pose
  def end_pose(path) do
    right_angle = (90 * get_sign path.angle)
    path.pose
    |> Pose.rotate(right_angle)
    |> Straight.new(path.radius)
    |> PathLike.pose_end()
    |> Pose.rotate(180 + path.angle)
    |> Straight.new(path.radius)
    |> PathLike.pose_end()
    |> Pose.rotate(right_angle)
  end
  def bounding_rect(path) do
    {x_start, y_start} = path |> start_pose() |> Position.to_tuple()
    {x_end, y_end} = path |> end_pose() |> Position.to_tuple()
    {xmin, xmax} = Enum.min_max([x_start, x_end])
    {ymin, ymax} = Enum.min_max([y_start, y_end])
    Rect.new(xmin, ymin, xmax, ymax)
  end

  # *** *******************************
  # *** API

  def get_radius(path), do: path.radius

  def get_angle_radians(path) do
    path.angle * :math.pi() / 180
  end

  def split(%__MODULE__{angle: angle_orig} = path, angle) when angle_orig > angle do
    ratio = angle / angle_orig
    path1 = new(
      path.pose,
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

  # *** *******************************
  # *** PRIVATE

  defp get_sign(number) when number > 0, do: 1
  defp get_sign(_number), do: -1

  defp radius(length, angle) do
    (length * 360) / (2 * :math.pi() * abs(angle))
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl PathLike do
    def pose_start(path), do: path.pose
    def pose_end(path), do: Turn.end_pose(path)
    def len(path), do: path.length
    def get_bounding_rect(path), do: Turn.bounding_rect(path)
  end
end

