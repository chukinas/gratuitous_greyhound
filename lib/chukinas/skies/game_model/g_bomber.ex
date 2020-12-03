defmodule Chukinas.Skies.Game.Bomber do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  @type id() :: {x ::integer(), y :: integer()}

  typedstruct enforce: true do
    field :element, integer()
    field :location, id()
  end

  # *** *******************************
  # *** NEW

  @spec new(element :: integer(), id()) :: t()
  def new(element, location), do: %__MODULE__{
    element: element,
    location: location
  }

  @spec to_client_id(t()) :: String.t()
  def to_client_id(%__MODULE__{location: {x, y}}), do: "bomber_#{x}_#{y}"

  @spec id_from_client_id(String.t()) :: id()
  def id_from_client_id(client_id) do
    [_ | location] = String.split(client_id, "_")
    location
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

end
