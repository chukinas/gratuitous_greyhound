defmodule Statechart.Node.LocalName.Collection do

  alias Statechart.Node
  alias Statechart.Node.LocalName
  alias Statechart.Node.Moniker
  alias Statechart.Node.State, as: StateNode

  # *** *******************************
  # *** TYPES

  @type local_name :: any
  @type t :: %{
    {:uniq, LocalName.t} => Moniker.t,
    {:dup, LocalName.t} => [Moniker.t]
  }

  # *** *******************************
  # *** CONSTRUCTORS

  def empty, do: %{}

  @spec from_nodes([StateNode.t]) :: t
  def from_nodes(nodes) when is_list(nodes) do
    local_name = fn {local_name, _} -> local_name end
    node_name = fn {_, node_name} -> node_name end
    prefix_keys = fn
      {local_name, [node_name]} -> {uniq(local_name), node_name}
      {local_name, node_names} -> {dup(local_name), node_names}
    end
    nodes
    |> Stream.map(&Node.moniker/1)
    |> Stream.flat_map(&Moniker.recursive_stream/1)
    |> Stream.map(&Moniker.to_local_name_tuple/1)
    #|> Stream.reject(&is_nil/1)
    |> Stream.uniq
    |> Enum.group_by(local_name, node_name)
    |> Stream.map(prefix_keys)
    |> Enum.into(%{})
  end

  @spec from_monikers([Moniker.t]) :: t
  def from_monikers(monikers) when is_list(monikers) do
    local_name = fn {local_name, _} -> local_name end
    node_name = fn {_, node_name} -> node_name end
    prefix_keys = fn
      {local_name, [node_name]} -> {uniq(local_name), node_name}
      {local_name, node_names} -> {dup(local_name), node_names}
    end
    monikers
    |> Stream.flat_map(&Moniker.recursive_stream/1)
    |> Stream.map(&Moniker.to_local_name_tuple/1)
    #|> Stream.reject(&is_nil/1)
    |> Stream.uniq
    |> Enum.group_by(local_name, node_name)
    |> Stream.map(prefix_keys)
    |> Enum.into(%{})
  end

  # *** *******************************
  # *** CONVERTERS

  def fetch_moniker!(local_names, local_name) do
    case local_names[uniq(local_name)] do
      nil -> raise "#{local_name} not found in #{inspect local_names}"
      moniker -> moniker
    end
  end

  # *** *******************************
  # *** HELPERS

  defp uniq(local_name), do: {:uniq, local_name}
  defp dup(local_name), do: {:dup, local_name}

end
