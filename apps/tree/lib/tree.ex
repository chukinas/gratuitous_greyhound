defmodule Tree do
  use Util.GetterStruct
  alias Tree.Node

  #####################################
  # TYPES

  getter_struct do
    field :nodes, [Node.t()], default: []
  end

  #####################################
  # CONSTRUCTORS

  def new do
    %__MODULE__{nodes: [Node.root()]}
  end

  #####################################
  # REDUCERS

  @spec add_child(t, Node.t(), Node.fetch_spec()) :: t
  def add_child(%__MODULE__{} = tree, %Node{} = node, parent_spec) do
    if node.name in Enum.map(tree.nodes, &Node.name/1) do
      raise "node names must be unique!"
    end

    case fetch(tree, parent_spec) do
      :error ->
        raise "no such parent!"

      {:ok, %Node{rgt: parent_rgt} = parent} ->
        inserted_node_count = 1
        addend = 2 * inserted_node_count
        min_value = parent.lft
        nodes = Enum.map(tree.nodes, &Node.maybe_update_position(&1, min_value, addend))

        new_child =
          struct!(node,
            lft: parent_rgt,
            rgt: parent_rgt + 1,
            id: largest_id(tree) + 1
          )

        nodes = Enum.sort_by([new_child | nodes], &Node.lft/1)
        %__MODULE__{tree | nodes: nodes}
    end
  end

  #####################################
  # CONVERTERS (private)

  defp fetch(%__MODULE__{nodes: nodes}, fetch_spec) do
    case Enum.find(nodes, &Node.match?(&1, fetch_spec)) do
      nil -> :error
      %Node{} = node -> {:ok, node}
    end
  end

  defp largest_id(%__MODULE__{nodes: nodes}) do
    nodes
    |> Stream.map(&Node.id/1)
    |> Enum.max()
  end
end
