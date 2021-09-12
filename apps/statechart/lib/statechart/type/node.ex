defmodule Statechart.Type.Node do

  alias Statechart.Type.Event
  alias Statechart.Type.NodeName

  # *** *******************************
  # *** TYPES

  defmodule Transitions do
    @type t :: %{Event.t => NodeName.t}
    def put(transitions, event, next_node_name) do
      Map.put(transitions, event, next_node_name)
    end
  end

  @typedoc """
  A parent node may never be occupied (only leaf nodes can).
  If a parent node is ever entered, the state is moved automatically
  to the default child node. If there is no default, then the next
  node up will be checked for a default, etc.
  """
  @type default :: nil | NodeName.t

  @typedoc """
  A node is either a leaf or a parent.
  During compilation, nodes by be undetermined temporarily
  """
  @type node_type :: :not_yet_determined | :leaf | {:parent, default}

  use Util.GetterStruct
  getter_struct do
    field :name, NodeName.t
    field :transitions, Transitions.t, default: %{}
    field :type, node_type, default: :not_yet_determined
    field :from_nodes, [NodeName.t], default: []
    field :default_of, [NodeName.t], default: []
    field :actions, [{atom, fun}], default: []
    field :autotransition, nil | NodeName.t, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(NodeName.t) :: t
  def new(name), do: %__MODULE__{name: name}

  # *** *******************************
  # *** REDUCERS

  @spec put_transition(t, Event.t, NodeName.t) :: t
  def put_transition(node, event, next_node_name) do
    Map.update!(node, :transitions, &Transitions.put(&1, event, next_node_name))
  end

  def transitioned_from(node, from_node_name) do
    fun = fn from_nodes ->
      if from_node_name in from_nodes, do: from_nodes, else: [from_node_name | from_nodes]
    end
    Map.update!(node, :from_nodes, fun)
  end

  def put_default(%__MODULE__{type: {:parent, _}} = node, default_node_name) do
    %__MODULE__{node | type: {:parent, default_node_name}}
  end

  def mark_as_parent(node), do: %__MODULE__{node | type: {:parent, nil}}

  def mark_as_leaf_if_not_parent(node) do
    fun = fn
      {:parent, _} = type -> type
      _ -> :leaf
    end
    Map.update!(node, :type, fun)
  end

  def default_of(%__MODULE__{} = node, parent_node_name) do
    # TODO make sure parent_node_name is an actual parent of this node
    Map.update!(node, :default_of, &[parent_node_name | &1])
  end

  def put_action(%__MODULE__{} = node, action_type, fun) do
    Map.update!(node, :actions, &[{action_type, fun} | &1])
  end

  def put_autotransition(%__MODULE__{} = node, next_node_name) do
    if preexisting_node_name = node.autotransition do
      raise "#{name(node)} node already has an autotransition: #{preexisting_node_name}"
    else
      %__MODULE__{node | autotransition: next_node_name}
    end
  end

  # *** *******************************
  # *** CONVERTERS

  def get_next_state(%__MODULE__{transitions: transitions}, event) do
    transitions[event]
  end

  def name_tuple(%__MODULE__{} = node) do
    {node.name, node}
  end

  def local_name(node) do
    node
    |> name
    |> NodeName.local_name
  end

  def get_default(%__MODULE__{type: {:parent, value}}), do: value
  def get_default(%__MODULE__{type: :leaf, name: value}), do: value

  def on_enter_actions(%__MODULE__{} = node) do
    node
    |> actions
    |> Enum.map(fn {_, fun} -> fun end)
  end

  def fetch_autotransition(%__MODULE__{autotransition: autotransition}) do
    if autotransition do
      {:ok, autotransition}
    else
      :none
    end
  end

end
