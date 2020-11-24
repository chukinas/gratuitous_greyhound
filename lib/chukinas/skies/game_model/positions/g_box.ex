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
end
