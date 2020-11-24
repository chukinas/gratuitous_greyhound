defmodule Chukinas.Skies.Game.Box do

  # Terminology:
  # Location refers to the unique indentifier of a unique box on the board
  # Box is a Location with other data, e.g. allowed moves and their cost

  # *** *******************************
  # *** TYPES

  defstruct [
    :location,
    :moves,
  ]

  # TODO which are private?
  @type position :: :nose | :tail | :left | :right
  @type mode :: :determined | :evasive
  # TODO rename box_type
  @type location_type :: {:return, mode()} | :preapproach | :approach
  # TODO this is more general than box.
  @type altitude :: :high | :level | :low
  # TODO rename id?
  @type location :: {position(), location_type(), altitude()}
  @type cost :: integer()
  @type move :: {location(), cost()}
  @type t :: %__MODULE__{
    # TODO rename id
    location: location(),
    moves: [move()],
  }

  # *** *******************************
  # *** API



  # TODO I think these are defp?
  # TODO correct box_type refs to loc_type
  def box_type_to_string({:return, return_type}) do
    "return_" <> Atom.to_string(return_type)
  end
  def box_type_to_string(box_type), do: Atom.to_string(box_type)

  def box_type_from_string(box_type) do
    box_type
    |> String.split("_")
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
  end

  # TODO this returns a location, not a box
  def to_strings({pos, loc_type, alt}) do
    loc = {pos, loc_type, alt} = {
      Atom.to_string(pos),
      box_type_to_string(loc_type),
      Atom.to_string(alt),
    }
    id = loc
    |> Tuple.to_list()
    |> Enum.join("_")
    {pos, loc_type, alt, id}
  end

  # TODO this returns a location, not a box
  def from_strings({pos, loc_type, alt}) do
    {
      String.to_atom(pos),
      box_type_from_string(loc_type),
      String.to_atom(alt),
    }
  end

  def location_to_string(location) do
    {_, _, _, stringified_location} = to_strings(location)
    stringified_location
  end

  def location_from_string(location) do
    location
    |> String.split("_")
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
    |> normalize_location_tuple()
  end

  # *** *******************************
  # *** HELPERS

  defp normalize_location_tuple({pos, :return, return_type, alt}) do
    {pos, {:return, return_type}, alt}
  end
  defp normalize_location_tuple(location), do: location
end
