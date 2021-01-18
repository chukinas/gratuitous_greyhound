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

  @spec deg_to_rad(number()) :: number()
  defp deg_to_rad(angle_deg) do
    angle_deg * :math.pi() / 180
  end

end
