defmodule Statechart.Type.LocalNodeName do
  @moduledoc """
  The innermost NodeName element

  Unique local node names can be used to uniquely identify Nodes.
  """
  alias Statechart.Type.Root
  @type t :: atom | Root.t
end

defmodule Statechart.Type.LocalNodeNames do

  alias Statechart.Type.LocalNodeName
  alias Statechart.Type.NodeName
  alias Statechart.Type.Node
  alias Statechart.Type.Root

  # *** *******************************
  # *** TYPES

  @type local_name :: any
  @type t :: %{
    {:uniq, LocalNodeName.t} => NodeName.t,
    {:dup, LocalNodeName.t} => [NodeName.t]
  }

  # *** *******************************
  # *** CONSTRUCTORS

  def empty, do: %{}

  @spec from_nodes([Node.t]) :: t
  def from_nodes(nodes) when is_list(nodes) do
    to_pairs = fn
      [%Root{} = local] = name -> {local, name}
      [local_node_name | _] = node_name -> {local_node_name, node_name}
    end
    local_name = fn {local_name, _} -> local_name end
    node_name = fn {_, node_name} -> node_name end
    prefix_keys = fn
      {local_name, [node_name]} -> {uniq(local_name), node_name}
      {local_name, node_names} -> {dup(local_name), node_names}
    end
    nodes
    |> Stream.map(&Node.name/1)
    |> Stream.flat_map(&NodeName.recursive_stream/1)
    |> Stream.map(to_pairs)
    #|> Stream.reject(&is_nil/1)
    |> Stream.uniq
    |> Enum.group_by(local_name, node_name)
    |> Stream.map(prefix_keys)
    |> Enum.into(%{})
  end

  # *** *******************************
  # *** CONVERTERS

  def fetch_uniq_node_name(local_names, local_name) do
    case local_names[uniq(local_name)] do
      nil -> :error
      node_name -> {:ok, node_name}
    end
  end

  # *** *******************************
  # *** HELPERS

  defp uniq(local_name), do: {:uniq, local_name}
  defp dup(local_name), do: {:dup, local_name}

end
