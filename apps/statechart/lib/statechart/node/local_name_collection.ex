defmodule Statechart.Node.LocalName.Collection do

  alias Statechart.Node.Id
  alias Statechart.Node.Moniker

  # *** *******************************
  # *** TYPES

  # TODO Simplify this. I won't be alllowing duplicates for a long time, if ever
  @type node_id :: Id.t
  @type t :: %{
    {:uniq, Id.t} => Moniker.t,
    {:dup, Id.t} => [Moniker.t]
  }

  # *** *******************************
  # *** CONSTRUCTORS

  def empty, do: %{}

  @spec from_monikers([Moniker.t]) :: t
  def from_monikers(monikers) when is_list(monikers) do
    get_name = fn {name, _} -> name end
    get_moniker = fn {_, moniker} -> moniker end
    prefix_keys = fn
      {name, [moniker]} -> {uniq(name), moniker}
      {name, monikers} -> {dup(name), monikers}
    end
    monikers
    |> Stream.flat_map(&Moniker.unfold_up/1)
    |> Stream.map(&{Moniker.local_name(&1), &1})
    |> Stream.uniq
    |> Enum.group_by(get_name, get_moniker)
    |> Stream.map(prefix_keys)
    |> Enum.into(%{})
  end

  # *** *******************************
  # *** CONVERTERS

  def fetch_moniker!(local_names, node_id) do
    case local_names[uniq(node_id)] do
      nil -> raise "#{node_id} not found in #{inspect local_names}"
      moniker -> moniker
    end
  end

  # *** *******************************
  # *** HELPERS

  defp uniq(node_id), do: {:uniq, node_id}
  defp dup(node_id), do: {:dup, node_id}

end
