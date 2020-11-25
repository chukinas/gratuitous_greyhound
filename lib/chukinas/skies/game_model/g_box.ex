defmodule Chukinas.Skies.Game.Box do

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
  @type box_group :: position | :not_entered | :dogfight
  @typep mode :: :determined | :evasive
  @typep box_type :: {:return, mode()} | :preapproach | :approach
  # FIX this is more general than box.
  @typep altitude :: :high | :level | :low
  @typep id_not_entered :: :not_entered
  @typep id_dogfight :: {:dogfight, integer()}
  @typep id_position :: {position(), box_type(), altitude()}
  @typep id :: id_not_entered() | id_dogfight() | id_position()
  @typep cost :: integer()
  @typep move :: {id(), cost()}
  # TODO use this type in Fighter
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
    # TODO will this be a problem for :not_entered?
    id
    |> String.split("_")
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
    |> normalize_location_tuple()
  end

  #TODO spec
  def get_move_cost(box, end_box_id) do
    {_, cost} = find_move(box.moves, end_box_id)
    cost
  end

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

  defp normalize_location_tuple({pos, :return, return_type, alt}) do
    {pos, {:return, return_type}, alt}
  end
  defp normalize_location_tuple(id), do: id

  defp find_move(moves, box_id) do
    case Enum.find(moves, fn {box_id, _} -> box_id == box_id end) do
      nil ->
        IO.inspect(%{moves: moves, box_id: box_id})
        raise "no matching move"
      move -> move
    end
  end

end
