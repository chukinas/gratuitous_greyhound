defmodule Chukinas.Skies.Game.Bomber do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  # TODO rename id? do this for entire file
  # TODO this location is the same as Spaces.id...
  @type location() :: {x ::integer(), y :: integer()}
  @type id() :: location()

  typedstruct enforce: true do
    field :element, integer()
    field :location, location()
  end

  # TODO add shortcut for add comment header
  # TODO add shortcut for def func

  # *** *******************************
  # *** NEW

  @spec new(element :: integer(), location()) :: t()
  def new(element, location), do: %__MODULE__{
    element: element,
    location: location
  }

  # *** *******************************
  # *** API

  @spec to_client_id(t()) :: String.t()
  def to_client_id(%__MODULE__{location: {x, y}}), do: "bomber_#{x}_#{y}"

  @spec id_from_client_id(String.t()) :: location()
  def id_from_client_id(client_id) do
    [_ | location] = String.split(client_id, "_")
    location
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

end
