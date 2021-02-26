alias Chukinas.Geometry.{Path, Pose}
defmodule Path.Turn do

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
      Path.get_end_pose(path1),
      path.length - len1,
      angle_orig - angle
    )
    {path1, path2}
  end

  # *** *******************************
  # *** PRIVATE

  defp radius(length, angle), do: (length * 360) / (2 * :math.pi() * angle)
end
