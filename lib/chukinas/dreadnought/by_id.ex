defmodule Chukinas.Dreadnought.ById do

  def get!(enum, id) when is_integer(id) do
    case Enum.find(enum, :not_found, & &1.id == round(id)) do
      :not_found -> raise "\n\n!!!\n\nId of #{id} not found in #{inspect enum}\n\n!!!\n\n"
      item -> item
    end
  end

  def get(enum, id) do
    enum
    |> Enum.find(fn item -> id_match?(item, id) end)
  end

  def insert(enum, new_item) when is_list(enum) do
    new_enum =
      enum
      |> Enum.reject(fn item -> id_match? item, new_item end)
    [new_item | new_enum]
  end

  def replace(enum, item) when is_list(enum) do
    {non_matches1, [_match | non_matches2]} =
      Enum.split_while(enum, fn x -> not id_match?(x, item) end)
    Enum.concat(non_matches1, [item, non_matches2])
  end

  defp id_match?(%{id: id1}, %{id: id2}), do: id1 == id2
  defp id_match?(%{id: id}, sought_id), do: id == sought_id
end
