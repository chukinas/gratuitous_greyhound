defmodule Statechart.Node.Collection do
  @moduledoc """
  Node collection and functions for operating on it
  """

  alias __MODULE__, as: Nodes
  alias Statechart.Node
  alias Statechart.Node.State, as: StateNode
  alias Statechart.Node.Decision, as: DecisionNode
  alias Statechart.Node.Moniker

  # *** *******************************
  # *** TYPES

  @type t :: %{Moniker.t => Node.t}

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new() :: t
  def new(), do: %{}

  def new_with_root() do
    new()
    |> put_new_node!(Moniker.new_root() |> StateNode.new)
  end

  @spec from_node_names([Moniker.t]) :: t
  def from_node_names(node_names) do
    Map.new node_names, fn name -> {name, StateNode.new(name)} end
  end

  # *** *******************************
  # *** REDUCERS

  @spec put_new_node!(t, Node.t) :: t
  def put_new_node!(nodes, node) do
    node_name = Node.moniker(node)
    if Map.has_key?(nodes, node_name) do
      raise "`nodes` already has a node with this name!"
    end
    Map.put(nodes, node_name, node)
  end

  def identify_leaves_and_parents(nodes) do
    parent_node_names =
      nodes
      |> Map.values
      |> Stream.map(&Node.moniker/1)
      |> Stream.flat_map(&Moniker.ancestors/1)
      |> Enum.uniq
    mark = fn
      %DecisionNode{} = node ->
        node
      %StateNode{} = node ->
        if Node.moniker(node) in parent_node_names do
          StateNode.mark_as_parent(node)
        else
          StateNode.mark_as_leaf_if_not_parent(node)
        end
    end
    nodes
    |> Map.values
    |> Stream.map(mark)
    |> Map.new(&{Node.moniker(&1), &1})
  end

  def update_node!(nodes, fq_node_name, fun) do
    Map.update!(nodes, fq_node_name, fun)
  end

  # *** *******************************
  # *** CONVERTERS

  @spec get_node(t, Moniker.t) :: Node.t
  def get_node(nodes, %Moniker{} = node_name) do
    nodes[node_name]
  end

  def fetch_node!(nodes, moniker) do
    case get_node(nodes, moniker) do
      nil -> raise "No matching node!!!"
      node -> node
    end
  end

  def to_list(nodes), do: Map.values(nodes)

  def node_names(nodes), do: Map.keys(nodes)

  # *** *******************************
  # *** IMPLEMENTATIONS

  #defimpl Inspect do
  #  require IOP
  #  def inspect(nodes, _opts) do
  #    nodes
  #    |> Nodes.to_list
  #  end
  #end

end

defimpl Statechart.Render.Protocol, for: Map do
  alias Statechart.Node
  alias Statechart.Node.Collection, as: Nodes
  def render(nodes, statemachine) do
    nodes
    |> Nodes.to_list
    |> Enum.sort(Node)
    |> Enum.reduce(statemachine, fn node, statemachine ->
      Statechart.Render.Protocol.render(node, statemachine)
    end)
  end
end

