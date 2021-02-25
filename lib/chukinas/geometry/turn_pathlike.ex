alias Chukinas.Geometry.{Pose, Position, PathLike, Path, Point, Rect}

# TODO move this to geometry/turn.ex?
defimpl PathLike, for: Path.Turn do
  def pose_start(path), do: path.pose
  def pose_end(path) do
    radius = (path.length * 360) / (2 * :math.pi() * path.angle)
    right_angle = 90 * get_sign path.angle
    path.pose
    |> Pose.rotate(right_angle)
    |> Path.new_straight(radius)
    |> Path.get_end_pose()
    |> Pose.rotate(180 + path.angle)
    |> Path.new_straight(radius)
    |> Path.get_end_pose()
    |> Pose.rotate(right_angle)
  end
  def len(path), do: path.length

  # TODO get rid of?
  def get_bounding_rect(path) do
    {x_start, y_start} = path |> pose_start() |> Position.to_tuple()
    {x_end, y_end} = path |> pose_end() |> Position.to_tuple()
    {xmin, xmax} = Enum.min_max([x_start, x_end])
    {ymin, ymax} = Enum.min_max([y_start, y_end])
    Rect.new(Point.new(xmin, ymin), Point.new(xmax, ymax))
  end

  # *** *******************************
  # *** PRIVATE

  defp get_sign(number) when number > 0, do: 1
  defp get_sign(_number), do: -1
end
