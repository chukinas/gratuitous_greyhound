defmodule Statechart.Type.Nodes do
  @moduledoc """
  Node collection and functions for operating on it
  """

  alias Statechart.Type.Node
  alias Statechart.Type.NodeName
  alias Statechart.Type.Transition

  # *** *******************************
  # *** TYPES

  @type t :: %{NodeName.t => Node.t}

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new() :: t
  def new(), do: %{}

  @spec from_node_names([NodeName.t]) :: t
  def from_node_names(node_names) do
    Map.new node_names, fn name -> {name, Node.new(name)} end
  end

  # *** *******************************
  # *** REDUCERS

  defp put_new_node(nodes, node_name) do
    Map.put_new_lazy(nodes, node_name, fn -> Node.new(node_name) end)
  end

  @spec put_transition(t, Transition.t) :: t
  def put_transition(nodes, {node_name, event, next_node_name}) do
    nodes
    |> Map.update!(node_name, &Node.put_transition(&1, event, next_node_name))
    |> Map.update!(next_node_name, &Node.transitioned_from(&1, node_name))
  end

  def put_default(nodes, {parent_node_name, default_node_name}) do
    nodes
    |> Map.update!(parent_node_name, &Node.put_default(&1, default_node_name))
    |> Map.update!(default_node_name, &Node.default_of(&1, parent_node_name))
  end

  def identify_leaves_and_parents(nodes) do
    nodes =
      Enum.reduce(Map.keys(nodes), nodes, fn node_name, nodes ->
        Enum.reduce(NodeName.parents(node_name), nodes, fn parent_node_name, nodes ->
          nodes
          |> put_new_node(parent_node_name)
          |> Map.update!(parent_node_name, &Node.mark_as_parent/1)
          # Inefficient. I could rewrite this so I stop if already marked as parent
        end)
      end)
    nodes
    |> Map.values
    |> Stream.map(&Node.mark_as_leaf_if_not_parent/1)
    |> Map.new(&Node.name_tuple/1)
  end

  def update_node!(nodes, fq_node_name, fun) do
    Map.update!(nodes, fq_node_name, fun)
  end

  # *** *******************************
  # *** CONVERTERS

  def get_transitioned_state(nodes, node_name, event) do
    node_name
    |> NodeName.recursive_stream
    |> Stream.map(&get_transitioned_state_nore(nodes, &1, event))
    |> Stream.filter(& &1)
    |> Enum.take(1)
    |> List.first
  end

  @spec get_transitioned_state_nore(t, NodeName.t, Event.t) :: nil | NodeName.t
  defp get_transitioned_state_nore(nodes, node_name, event) do
    with node <- Map.fetch!(nodes, node_name),
         next_node_name when not is_nil(next_node_name) <- Node.get_next_state(node, event) do
      next_node_name
    else
      _ -> nil
    end
  end

  def get_node(nodes, node_name), do: nodes[node_name]

  def group_by_local_name(nodes) do
    nodes
    |> Map.values
    |> Enum.group_by(&NodeName.local_name/1)
  end

  def to_list(nodes), do: Map.values(nodes)

  def node_names(nodes), do: Map.keys(nodes)

  @doc """
  Follows a path of parents' defaults to a leaf node; returns leaf node's name

  Should raise if it doesn't end on a leaf.
  """
  def next_leaf_node_name(nodes, current_node_name) do
    next_node_name =
      nodes
      |> get_node(current_node_name)
      |> Node.get_default
    if next_node_name == current_node_name do
      current_node_name
    else
      goto_default(nodes, next_node_name)
    end
  end

  @deprecated "Use next_leaf_node_name/2 instead"
  def goto_default(nodes, current_node_name) do
    next_leaf_node_name(nodes, current_node_name)
  end

end
