defmodule Dreadnought.Angle do

  # *** *******************************
  # *** MACROS

  defmacro __using__(_opts) do
    quote do
      require Dreadnought.Angle
      alias Dreadnought.Angle
    end
  end

  # *** *******************************
  # *** ARCS

  def radius_from_angle_and_arclen(angle, arclen) do
    (360 * arclen) / (2 * :math.pi() * angle)
  end

  def angle_from_radius_and_arclen(radius, arclen) do
    (360 * arclen) / (2 * :math.pi() * radius)
  end

  def arclen_from_radius_and_angle(radius, angle) do
    (2 * :math.pi() * radius * angle) / 360
  end

  # *** *******************************
  # *** REDUCERS

  def normalize(angle) do
    cond do
      angle < 0 ->
        normalize(angle + 360)
      angle >= 360 ->
        normalize(angle - 360)
      true ->
        angle
    end
  end

  def deg_to_rad(angle), do: angle * :math.pi() / 180

  def rad_to_deg(angle), do: angle * 180 / :math.pi()

  # *** *******************************
  # *** GUARDS

  defguard is_normal(angle)
    when angle >= 0
    and angle < 360

end
