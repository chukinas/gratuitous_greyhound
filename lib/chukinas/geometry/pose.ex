alias Chukinas.Geometry.{Pose, Position}
defmodule Pose do

  import Position.Guard

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :angle, number()
  end

  # *** *******************************
  # *** NEW
  #

  def new(position, angle) when has_position(position) do
    new(position.x, position.y, angle)
  end
  def new(x, y, angle) do
    %__MODULE__{
      x: x,
      y: y,
      angle: angle,
    }
  end

  # *** *******************************
  # *** API

  def origin(), do: new(0, 0, 0)

  def rotate(%__MODULE__{} = pose, angle) do
    %{pose | angle: normalize_angle(pose.angle + angle)}
  end

  def get_intercept(pose1, pose2) do

  end

  # *** *******************************
  # *** PRIVATE

  defp normalize_angle(angle) when angle > 360, do: normalize_angle(angle - 360)
  defp normalize_angle(angle) when angle < -360, do: normalize_angle(angle + 360)
  defp normalize_angle(angle), do: angle

  defp calc_slope(pose) do
    pose |> get_radians() |> :math.tan()
  end

  defp get_radians(degrees), do: degrees * :math.pi() / 180
end
