defmodule Statechart.Machine.Spec do
  @moduledoc """
  Data structure that fully defines a `Statechart` machine.

  It get interpreted by the Statechart.Machine
  """

  alias Statechart.Machine.Accumulator
  alias Statechart.Type.Context
  alias Statechart.Type.LocalNodeNames
  alias Statechart.Type.Node
  alias Statechart.Type.NodeName
  alias Statechart.Type.Nodes

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :context, Context.t
    field :nodes, Nodes.t, default: Nodes.new()
    field :local_names, LocalNodeNames.t, default: LocalNodeNames.empty()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(context), do: %__MODULE__{context: context}

  @spec from_accumulator(Accumulator.t) :: t
  def from_accumulator(%Accumulator{} = acc) do
    new(acc.context)
    |> put_states(acc.states)
    |> eval_leaves_and_parents
    |> eval_local_names
    |> put_transitions(acc.transitions)
    |> put_defaults(acc.defaults)
    |> put_actions(acc.actions)
    |> put_autotransitions(acc.autotransitions)
  end

  # *** *******************************
  # *** REDUCERS

  def put_new_state(spec, node_name) do
    with nodes <- nodes(spec),
         false <- Map.has_key?(nodes) do
      %{nodes | node_name => Node.new(node_name)}
    else
      _ -> spec
    end
  end

  # *** *******************************
  # *** REDUCERS (private)

  defp put_states(%__MODULE__{} = spec, states) do
    %__MODULE__{spec | nodes: Nodes.from_node_names(states)}
  end

  defp put_transitions(spec, transitions) do
    Enum.reduce(transitions, spec, &put_transition(&2, &1))
  end

  defp put_transition(%__MODULE__{} = spec, {from, event, to} = _transition) do
    {:ok, fully_qual_node_name} = fetch_fully_qualified_node_name(spec, to)
    Map.update!(spec, :nodes, &Nodes.put_transition(&1, {from, event, fully_qual_node_name}))
  end

  defp eval_leaves_and_parents(%__MODULE__{} = spec) do
    Map.update! spec, :nodes, &Nodes.identify_leaves_and_parents/1
  end

  defp eval_local_names(%__MODULE__{nodes: nodes} = spec) do
    %__MODULE__{spec | local_names: nodes |> Nodes.to_list |> LocalNodeNames.from_nodes}
  end

  defp put_defaults(%__MODULE__{} = spec, defaults) do
    Enum.reduce defaults, spec, &put_default(&2, &1)
  end

  defp put_default(%__MODULE__{} = spec, {from_node, to_node}) do
    fully_qualified_to_node =
      case fetch_fully_qualified_node_name(spec, to_node) do
        {:ok, node_name} ->
          node_name
        :error ->
          raise """
          `#{inspect to_node}` is not a valid node. It does not exit.
          Pass a fully qualified node name (e.g. `[:inner, :middle, :outer]`)
          or a unique local name (e.g. `:inner`).
          """
      end
    Map.update! spec, :nodes, &Nodes.put_default(&1, {from_node, fully_qualified_to_node})
  end

  defp put_actions(%__MODULE__{} = spec, actions) when is_list(actions) do
    Enum.reduce(actions, spec, fn {action_type, node_name, fun}, spec ->
      update_node_fun = &Node.put_action(&1, action_type, fun)
      update_node!(spec, node_name, update_node_fun)
    end)
  end

  defp put_autotransitions(%__MODULE__{} = spec, autotransitions) do
    Enum.reduce(autotransitions, spec, fn {node_name, next_node_name}, spec ->
      {:ok, fq_next_node_name} = fetch_fully_qualified_node_name(spec, next_node_name)
      update_node_fun = &Node.put_autotransition(&1, fq_next_node_name)
      update_node!(spec, node_name, update_node_fun)
    end)
  end

  # *** *******************************
  # *** CONVERTERS

  def fetch_next_state(spec, node_name, event) do
    nodes = spec.nodes
    case Nodes.get_transitioned_state(nodes, node_name, event) do
      nil ->
        {:error, "No Matching Transition"}
      node_name ->
        next_leaf_node_name = Nodes.next_leaf_node_name(nodes, node_name)
        {:ok, next_leaf_node_name}
    end
  end

  def initial_node_name(spec) do
    spec
    |> nodes
    |> Nodes.next_leaf_node_name(NodeName.root())
  end

  def node!(spec, node_name) do
    {:ok, fq_node_name} = fetch_fully_qualified_node_name(spec, node_name)
    spec
    |> nodes
    |> Nodes.get_node(fq_node_name)
  end

  def update_node!(spec, node_name, fun) do
    {:ok, fq_node_name} = fetch_fully_qualified_node_name(spec, node_name)
    Map.update!(spec, :nodes, fn nodes -> Nodes.update_node!(nodes, fq_node_name, fun) end)
  end

  def fetch_fully_qualified_node_name(spec, node_name) when is_atom(node_name) do
    LocalNodeNames.fetch_uniq_node_name(spec.local_names, node_name)
  end
  def fetch_fully_qualified_node_name(spec, node_name) when is_list(node_name) do
    if node_name in Nodes.node_names(spec.nodes) do
      {:ok, node_name}
    else
      :error
    end
  end

  def on_enter_actions(%__MODULE__{} = spec, node_name) do
    spec
    |> node!(node_name)
    |> Node.on_enter_actions
  end

end
