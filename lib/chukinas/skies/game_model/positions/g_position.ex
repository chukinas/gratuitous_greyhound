defmodule Chukinas.Skies.Game.Box do

  # *** *******************************
  # *** TYPES

  defstruct [
    :location,
    :moves,
  ]

  # TODO rename file g_box
  # TODO rename attack direction?
  @type generic_direction :: :nose | :tail | :flank
  # TODO rename this to simply be direction
  @type specific_direction :: :nose | :tail | :left | :right
  @type mode :: :determined | :evasive
  @type location_type :: {:return, mode()} | :preapproach | :approach
  @type altitude :: :high | :level | :low
  @type location :: {specific_direction(), location_type(), altitude()}
  @type cost :: integer()
  @type move :: {location(), cost()}
  # TODO not_entered_should be a location?
  @type t :: %__MODULE__{
    location: location(),
    moves: [move()],
  }

  # *** *******************************
  # *** API

  @spec to_generic(specific_direction()) :: generic_direction()
  def to_generic(direction) do
    case direction do
      :right -> :flank
      :left  -> :flank
      other -> other
    end
  end
end
