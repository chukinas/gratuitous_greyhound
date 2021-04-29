defmodule Chukinas.Dreadnought.ById do

  # *** *******************************
  # *** API

  def get!(items, ids) when is_list(ids) do
    ids
    |> Enum.map(& get!(items, &1))
  end
  def get!(enum, id) when is_integer(id) do
    case Enum.find(enum, :not_found, & &1.id == round(id)) do
      :not_found -> raise "\n\n!!!\n\nId of #{id} not found in #{inspect enum}\n\n!!!\n\n"
      item -> item
    end
  end

  def put(enum, item) when is_list(enum) do
    replace(enum, item)
  end

  def replace(enum, item) when is_list(enum) do
    case Enum.split_while(enum, &_not_match?(&1, item)) do
      {non_matches1, [_match | non_matches2]} ->
        non_matches1 ++ [item | non_matches2]
      {non_matches1, []} ->
        [item | non_matches1]
    end
  end

  def replace!(enum, item) when is_list(enum) do
    {non_matches1, [_match | non_matches2]} =
      Enum.split_while(enum, &_not_match?(&1, item))
    Enum.concat(non_matches1, [item | non_matches2])
  end

  def to_ids(enum) when is_list(enum) do
    Enum.map(enum, & &1.id)
  end

  # *** *******************************
  # *** PRIVATE

  defp _match?(%{id: id1}, %{id: id2}), do: id1 == id2
  defp _match?(%{id: id}, sought_id), do: id == sought_id

  defp _not_match?(a, b), do: not _match?(a, b)
end
