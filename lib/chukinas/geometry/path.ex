defprotocol Chukinas.Geometry.Path do
  def pose_start(path)
  def pose_end(path)
  def len(path)
end

defimpl Chukinas.Geometry.Path, for: Chukinas.Geometry.Path.Straight do
  alias Chukinas.Geometry.Polar
  alias Chukinas.Geometry.Pose
  def pose_start(path), do: path.start
  def pose_end(path) do
    len = len(path)
    %{x: x0, y: y0, angle: angle} = pose_start(path)
    %{x: dx, y: dy} = Polar.new(len, angle)
    |> Polar.to_cartesian()
    Pose.new(x0 + dx, y0 + dy, angle)
  end
  def len(path), do: path.len
end
