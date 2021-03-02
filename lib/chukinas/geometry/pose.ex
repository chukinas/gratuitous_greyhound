alias Chukinas.Geometry.{Pose, Position}
defmodule Pose do

  require Position

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :angle, number()
  end

  # *** *******************************
  # *** NEW

  def new(position, angle) when Position.is(position) do
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

  # *** *******************************
  # *** PRIVATE

  defp normalize_angle(angle) when angle > 360, do: normalize_angle(angle - 360)
  defp normalize_angle(angle) when angle < -360, do: normalize_angle(angle + 360)
  defp normalize_angle(angle), do: angle

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    def inspect(pose, _opts) do
      "#Pose<#{round pose.x}, #{round pose.y} ∠ #{round pose.angle}°>"
    end
  end
end
