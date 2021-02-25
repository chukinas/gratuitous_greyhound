alias Chukinas.Geometry.{Polar, Pose, Position, PathLike, Path, Point, Rect}

defimpl PathLike, for: Path.Turn do
  def pose_start(path), do: path.start
  def pose_end(path) do
    len = len(path)
    %{x: x0, y: y0, angle: angle} = pose_start(path)
    %{x: dx, y: dy} = Polar.new(len, angle)
    |> Polar.to_cartesian()
    Pose.new(x0 + dx, y0 + dy, angle)
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
end
