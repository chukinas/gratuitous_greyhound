defmodule Util.IdList do

  # *** *******************************
  # *** CONSTRUCTORS

  # *** *******************************
  # *** REDUCERS

  def drop(enum, id, key \\ :id) do
    Enum.filter(enum, fn item -> _not_match?(item, id, key) end)
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

  def overwrite!(enum, %{} = item, key \\ :id) do
    do_overwrite(enum, [], item, key)
  end

  defp do_overwrite([], _non_matches, _item, _key), do: raise(Enum.OutOfBoundsError, "List didn't contain matching item!")
  defp do_overwrite([head | tail], non_matches, item, key) do
    if _match?(head, item, key) do
      # Replay non-matches back onto tail
      Enum.reduce(non_matches, [item | tail], fn non_match, acc ->
        [non_match | acc]
      end)
    else
      do_overwrite(tail, [head | non_matches], item, key)
    end
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

  # *** *******************************
  # *** CONVERTERS

  def fetch_by_player_id!(items, player_id) when is_list(items) and is_integer(player_id) do
    fetch!(items, player_id, :player_id)
  end

  def fetch!(items, ids, key \\ :id)
  def fetch!(items, ids, key) when is_list(ids) do
    ids
    |> Enum.map(& fetch!(items, &1, key))
  end
  def fetch!(enum, id, key) when length(enum) > 0 and is_integer(id) do
    case Enum.find(enum, :not_found, &_match?(&1, id, key)) do
      :not_found ->
        pair = %{key: key, value: id}
        raise "\n\n!!!\n\nItem #{inspect pair} not found in #{inspect enum}\n\n!!!\n\n"
      item ->
        item
    end
  end

  def ids(enum, key \\ :id) when is_list(enum) do
    Stream.map(enum, & Map.fetch!(&1, key))
  end

  def next_id(enum, key \\ :id) when is_list(enum) do
    enum
    |> ids(key)
    |> Enum.max(&>=/2, fn -> 0 end)
    |> Kernel.+(1)
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
