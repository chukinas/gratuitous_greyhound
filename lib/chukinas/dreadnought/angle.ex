defmodule Chukinas.Dreadnought.Angle do
  @moduledoc """
  Abstraction of an angle, with fields such as `:rad` and `:negative?`
  """

  # *** *******************************
  # *** TYPES
  
  use TypedStruct

  typedstruct enforce: true do
    field :deg, number()
    field :deg_abs, number()
    field :rad, number()
    field :rad_abs, number()
    field :negative?, boolean()
  end

  # *** *******************************
  # *** NEW

  @doc """
  Create new Angle struct from angle (degrees)

  ## Examples

      iex> Chukinas.Dreadnought.Angle.new(0)
      %Chukinas.Dreadnought.Angle{deg: 0, deg_abs: 0, negative?: false, rad: 0.0, rad_abs: 0.0}

      iex> Chukinas.Dreadnought.Angle.new(-24.5)
      %Chukinas.Dreadnought.Angle{deg: -24.5, deg_abs: 24.5, negative?: true, rad: -0.4276056667386107, rad_abs: 0.4276056667386107}

  """
  def new(angle_deg) when is_number(angle_deg) do
    rad = angle_deg |> deg_to_rad()
    %__MODULE__{
      deg: angle_deg,
      deg_abs: abs(angle_deg),
      rad: rad,
      rad_abs: abs(rad),
      negative?: rad < 0,
    }
  end

  # *** *******************************
  # *** SIGN

  @doc """
  Return `-1` or `1`, the sign of which matches the sign of the angle

  ## Examples
  
      iex> alias Chukinas.Dreadnought.Angle
      iex> Angle.new(-45)
      ...> |> Angle.get_sign()
      -1
  """
  def get_sign(%__MODULE__{}=angle) do
    _get_sign(angle.deg)
  end
  def get_sign(angle) when is_number(angle) do
    _get_sign(angle)
  end
  defp _get_sign(angle) when angle < 0, do: -1
  defp _get_sign(_angle), do: 1

  # *** *******************************
  # *** SPIN 90

  @doc """
  Add 90deg if argument is positive; subtract if negative

  ## Examples
  
      iex> alias Chukinas.Dreadnought.Angle
      iex> Angle.new(-45)
      ...> |> Angle.spin_90(60)
      %Angle{deg: 45, deg_abs: 45, negative?: false, rad: 0.7853981633974483, rad_abs: 0.7853981633974483}
  """
  def spin_90(%__MODULE__{}=angle, direction) do
    rotation_deg = 90 * get_sign(direction)
    new(angle.deg + rotation_deg)
  end

  # *** *******************************
  # *** HELPERS

  @spec deg_to_rad(number()) :: number()
  defp deg_to_rad(angle_deg) do
    angle_deg * :math.pi() / 180
  end

end
