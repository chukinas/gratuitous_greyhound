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
        min_value = parent.rgt
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
  # CONVERTERS

  # TODO rename to get_path_of?
  @spec get_path(t, Node.t() | Node.fetch_spec(), (Node.t() -> term)) :: [term]
  def get_path(tree, node, mapper \\ fn node -> node end)

  def get_path(tree, %Node{} = node, mapper) do
    tree
    |> nodes
    |> Stream.take_while(fn %Node{lft: lft} -> lft <= node.lft end)
    |> Stream.filter(fn %Node{rgt: rgt} -> node.rgt <= rgt end)
    |> Enum.map(mapper)
  end

  def get_path(tree, fetch_spec, mapper) do
    node = fetch(tree, fetch_spec)
    get_path(tree, node, mapper)
  end

  def fetch_parent_of!(tree, %Node{} = node) do
    tree
    |> get_path(node)
    |> Stream.reject(fn %Node{lft: lft} -> lft == node.lft end)
    |> Enum.at(-1)
  end

  def fetch_parent_of!(tree, fetch_spec) do
    {:ok, node} = fetch(tree, fetch_spec)
    fetch_parent_of!(tree, node)
  end

  def fetch(%__MODULE__{nodes: nodes}, fetch_spec) do
    case Enum.find(nodes, &Node.match?(&1, fetch_spec)) do
      nil -> :error
      %Node{} = node -> {:ok, node}
    end
  end

  def map_nodes(tree, mapper) do
    tree |> nodes |> Enum.map(mapper)
  end

  #####################################
  # CONVERTERS (private)

  defp largest_id(%__MODULE__{nodes: nodes}) do
    nodes
    |> Stream.map(&Node.id/1)
    |> Enum.max()
  end

  #####################################
  # IMPLEMENTATIONS

  # defimpl Inspect do
  #   def inspect(tree, opts) do
  #     Util.Inspect.custom_kv("Tree", tree.nodes, opts)
  #   end
  # end
end
