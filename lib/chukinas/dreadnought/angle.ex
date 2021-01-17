defmodule Chukinas.Dreadnought.Angle do

  use TypedStruct

  typedstruct enforce: true do
    field :deg, number()
    field :rad, number()
  end

  @doc """
  Create new Angle struct from angle (degrees)

  ## Examples

      iex> Chukinas.Dreadnought.Angle.new(0)
      %Chukinas.Dreadnought.Angle{deg: 0, rad: 0.0}

      iex> Chukinas.Dreadnought.Angle.new(24.5)
      %Chukinas.Dreadnought.Angle{deg: 24.5, rad: 0.4276056667386107}
  """
  def new(angle_deg) do
    %__MODULE__{
      deg: angle_deg,
      rad: deg_to_rad angle_deg
    }
  end

  @spec deg_to_rad(number()) :: number()
  defp deg_to_rad(angle_deg) do
    angle_deg * :math.pi() / 180
  end

end
