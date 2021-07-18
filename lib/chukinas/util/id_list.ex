defmodule Chukinas.Util.IdList do

  # *** *******************************
  # *** API

  def fetch!(items, ids, key \\ :id)
  def fetch!(items, ids, key) when is_list(ids) do
    ids
    |> Enum.map(& fetch!(items, &1, key))
  end
  def fetch!(enum, id, key) do
    case Enum.find(enum, :not_found, &_match?(&1, id, key)) do
      :not_found ->
        pair = %{key: key, value: id}
        raise "\n\n!!!\n\nItem #{inspect pair} not found in #{inspect enum}\n\n!!!\n\n"
      item ->
        item
    end
  end

  def put(enum, item_or_items, key \\ :id)
  def put(enum, items, key) when is_tuple(items) do
    put(enum, Tuple.to_list(items), key)
  end
  def put(enum, items, key) when is_list(items) do
    Enum.reduce(items, enum, fn item, enum -> put(enum, item, key) end)
  end
  def put(enum, item, key) when is_list(enum) do
    replace(enum, item, key)
  end

  def ids(enum, key \\ :id) when is_list(enum) do
    Stream.map(enum, & Map.fetch!(&1, key))
  end

  def update!(enum, id, key \\ :id, fun) do
    {:found, list} =
      Enum.reduce enum, {:still_looking, []}, fn
        item, {:still_looking, list} ->
          if _match?(item, id, key) do
            {:found, [fun.(item) | list]}
          else
            {:still_looking, [item | list]}
          end
        item, {result, list} ->
          {result, [item | list]}
      end
    list
    |> Enum.reverse
  end

  def drop(enum, id, key \\ :id) do
    Enum.filter(enum, fn item -> _not_match?(item, id, key) end)
  end

  # *** *******************************
  # *** PRIVATE

  defp _match?(%{} = a, %{} = b, key) do
    Map.fetch!(a, key) == Map.fetch!(b, key)
  end
  defp _match?(%{} = a, sought_id, key) do
    (Map.fetch!(a, key) == sought_id)
  end

  defp _not_match?(a, b, key), do: not _match?(a, b, key)

  defp replace(enum, item, key) when is_list(enum) do
    case Enum.split_while(enum, &_not_match?(&1, item, key)) do
      {non_matches1, [_match | non_matches2]} ->
        non_matches1 ++ [item | non_matches2]
      {non_matches1, []} ->
        [item | non_matches1]
    end
  end
end
