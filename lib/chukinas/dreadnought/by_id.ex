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
    #[item | Enum.reject(enum, fn list_item ->
    #  _match?(item, list_item)
    #end)]
    replace(enum, item)
  end

  def replace(enum, item) when is_list(enum) do
    {non_matches1, non_matches2} =
      Enum.split_while(enum, fn x -> not _match?(x, item) end)
    Enum.concat(non_matches1, case non_matches2 do
      [] -> [item]
      [_match | non_matches3] -> [item | non_matches3]
    end)
  end

  def replace!(enum, item) when is_list(enum) do
    {non_matches1, [_match | non_matches2]} =
      Enum.split_while(enum, fn x -> not _match?(x, item) end)
    Enum.concat(non_matches1, [item, non_matches2])
  end

  def to_ids(enum) when is_list(enum) do
    Enum.map(enum, & &1.id)
  end

  # *** *******************************
  # *** PRIVATE

  defp _match?(%{id: id1}, %{id: id2}), do: id1 == id2
  defp _match?(%{id: id}, sought_id), do: id == sought_id
end
