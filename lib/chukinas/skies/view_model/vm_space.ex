defmodule Chukinas.Skies.ViewModel.Space do

  alias Chukinas.Skies.Common, as: C
  alias Chukinas.Skies.Game.Space, as: G_Space

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :x, integer()
    field :y, integer()
    field :lethal_level, any()
    field :coordinates_tailwind, String.t()
  end

  # *** *******************************
  # *** BUILD

  @spec build(G_Space.t()) :: t()
  def build(space) do
    %__MODULE__{
      x: space.x,
      y: space.y,
      lethal_level: space.lethal_level,
      coordinates_tailwind: coordinates_tailwind(space),
    }
  end

  # *** *******************************
  # *** HELPERS

  # TODO snippet defp

  @spec coordinates_tailwind(G_Space.t()) :: String.t()
  defp coordinates_tailwind(space) do
    space.id
    |> Tuple.to_list()
    |> Enum.map(&start_int_tailwind/1)
    |> List.to_tuple()
    |> coordinates_to_tailwind()
  end

  @spec start_int_tailwind(integer()) :: integer()
  defp start_int_tailwind(c) do
    (c * 2) -1
  end

  @spec coordinates_to_tailwind(C.coordinates()) :: String.t()
  defp coordinates_to_tailwind({x, y}) do
    "col-start-#{x} row-start-#{y}"
  end


end
