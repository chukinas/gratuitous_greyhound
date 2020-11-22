defmodule Chukinas.Skies.Game.IdAndState do

  @type state :: :not_avail | :pending | :selected | :complete
  # """
  # For anything with id and state
  # """

  # TODO can this be defp?
  # TODO should items and id be swapped?
  def apply_if_matching_id(items, id, func) when is_integer(id) do
    Enum.map(items, fn item ->
      if item.id == id do
        func.(item)
      else
        item
      end
    end)
  end

  def apply_if_matching_id(items, ids, func) when is_list(ids) do
    Enum.map(items, fn item ->
      if Enum.member?(ids, item.id) do
        func.(item)
      else
        item
      end
    end)
  end

  def get_item(items, id) do
    Enum.find(items, &(&1.id == id))
  end

  def get_items(ids, items) do
    Enum.filter(items, &(Enum.member?(ids, &1.id)))
  end

  # @spec selected?(t()) :: boolean()
  def selected?(item), do: item.state == :selected
  def get_single_selected(items), do: Enum.find(items, &selected?/1)
  def get_selected(items), do: Enum.filter(items, &selected?/1)

  def get_list_of_ids(items) do
    Enum.map(items, &(&1.id))
  end
  def done?(item) do
    Enum.member?([:not_avail, :complete], item.state)
  end

end
