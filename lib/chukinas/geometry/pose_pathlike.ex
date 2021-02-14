# TODO is this actually used anywhere?

alias Chukinas.Geometry.{Pose, Point, IsPath, Rect}

# TODO rename PathLike
defimpl IsPath, for: Pose do

  def pose_start(pose), do: pose

  def pose_end(pose), do: pose

  def len(_pose), do: 0

  def get_bounding_rect(pose) do
    point = Point.new(pose)
    Rect.new(point, point)
  end
end
