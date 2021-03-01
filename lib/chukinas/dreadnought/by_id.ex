defmodule Chukinas.Dreadnought.ById do

  def get_by_id(enum, id) do
    enum
    |> Enum.find(fn item -> id_match?(item, id) end)
  end

  def insert_by_id(enum, new_item) when is_list(enum) do
    new_enum =
      enum
      |> Enum.reject(fn item -> id_match? item, new_item end)
    [new_item | new_enum]
  end

  def replace_by_id(enum, item) when is_list(enum) do
    {non_matches1, [_match | non_matches2]} =
      Enum.split_while(enum, fn x -> not id_match?(x, item) end)
    Enum.concat(non_matches1, [item, non_matches2])
  end

  defp id_match?(%{id: id1}, %{id: id2}), do: id1 == id2
  defp id_match?(%{id: id}, sought_id), do: id == sought_id
end
