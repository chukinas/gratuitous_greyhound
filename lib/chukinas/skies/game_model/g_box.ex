defmodule Chukinas.Skies.Game.Box do

  alias Chukinas.Skies.Game.EscortStation

  # Terminology:
  # Location refers to the unique indentifier of a unique box on the board
  # Box is a Location with other data, e.g. allowed moves and their cost

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :moves,
  ]

  @type position :: :nose | :tail | :left | :right
  # NOTE: if any of these have an underscore, it'll cause errors in id_from_string
  @type box_group :: position | :notentered | :dogfight
  @typep mode :: :determined | :evasive
  @typep box_type :: {:return, mode()} | :preapproach | :approach
  # FIX this is more general than box.
  @typep altitude :: :high | :level | :low
  @typep id_notentered :: :notentered
  @typep id_dogfight :: {:dogfight, integer()}
  @typep id_position :: {position(), box_type(), altitude()}
  @type id ::
    id_notentered() |
    id_dogfight() |
    id_position() |
    EscortStation.id()
  @typep cost :: integer()
  @typep move :: {id(), cost()}
  @type fighter_move :: {id(), id()}
  @type t :: %__MODULE__{
    id: id(),
    moves: [move()],
  }

  # *** *******************************
  # *** API

  @spec id_to_string(id()) :: String.t()
  def id_to_string(id) when is_atom(id), do: Atom.to_string(id)
  def id_to_string({:dogfight, index}), do: "dogfight_#{index}"
  def id_to_string({pos, loc_type, alt}) do
    [
      Atom.to_string(pos),
      box_type_to_string(loc_type),
      Atom.to_string(alt),
    ]
    |> Enum.join("_")
  end

  @spec id_from_string(String.t()) :: id()
  def id_from_string(id) do
    id
    |> String.split("_")
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
    |> normalize_location_tuple()
  end

  @spec get_move_cost(t(), id()) :: integer()
  def get_move_cost(_box, nil), do: 0
  def get_move_cost(box, end_box_id) do
    {_, cost} = find_move(box.moves, end_box_id)
    cost
  end

  def approach?({_, :approach, _}), do: true
  def approach?(_), do: false

  # *** *******************************
  # *** HELPERS

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

  defp normalize_location_tuple({atom}), do: atom
  defp normalize_location_tuple({pos, :return, return_type, alt}) do
    {pos, {:return, return_type}, alt}
  end
  defp normalize_location_tuple(id), do: id

  defp find_move(moves, box_id) do
    case Enum.find(moves, &matching_move?(&1, box_id)) do
      nil ->
        raise "no matching move"
      move -> move
    end
  end

  defp matching_move?({id, _}, box_id), do: id == box_id

end
