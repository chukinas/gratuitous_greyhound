alias Chukinas.Geometry.{Polar, Pose, Position, IsPath, Path}

# TODO rename to CHukinas.geometry.path.ispath
defprotocol IsPath do
  def pose_start(path)
  def pose_end(path)
  def len(path)

  @doc """
  Returns a map describing the smallest rectangle that fully bounds the path.
  The x,y coordinates describe the corner closest to the origin.
  `width` and `height` describe the size of the box.
  """
  def view_box(path, margin \\ 0)
end

defimpl IsPath, for: Path.Straight do
  def pose_start(path), do: path.start
  def pose_end(path) do
    len = len(path)
    %{x: x0, y: y0, angle: angle} = pose_start(path)
    %{x: dx, y: dy} = Polar.new(len, angle)
    |> Polar.to_cartesian()
    Pose.new(x0 + dx, y0 + dy, angle)
  end
  def len(path), do: path.len

  # TODO rename get_bounding_rect
  def view_box(path, margin \\ 0) do
    {x_start, y_start} = path |> pose_start() |> Position.to_tuple()
    {x_end, y_end} = path |> pose_end() |> Position.to_tuple()
    {xmin, xmax} = Enum.min_max([x_start, x_end])
    {ymin, ymax} = Enum.min_max([y_start, y_end])
    %{
      x: xmin - x_start - margin,
      y: ymin - y_start - margin,
      width: xmax - xmin + 2 * margin,
      height: ymax - ymin + 2 * margin
    }
  end
end
