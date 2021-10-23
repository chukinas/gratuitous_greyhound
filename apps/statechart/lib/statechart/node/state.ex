defmodule Statechart.Node.State do

  alias Statechart.Node.Moniker
  alias Statechart.Event

  # *** *******************************
  # *** TYPES

  # TODO unneeded
  defmodule Transitions do
    @type t :: %{Event.t => Moniker.t}
    def put(transitions, event, next_node_name) do
      Map.put(transitions, event, next_node_name)
    end
    def render(transitions) do
      for {event, %Moniker{} = to} <- transitions do
        %{
          to: Moniker.local_name(to),
          event: event
        }
      end
    end
  end

  @typedoc """
  A parent node may never be occupied (only leaf nodes can).
  If a parent node is ever entered, the state is moved automatically
  to the default child node. If there is no default, then the next
  node up will be checked for a default, etc.
  """
  @type default :: nil | Moniker.t

  @typedoc """
  A node is either a leaf or a parent.
  During compilation, nodes by be undetermined temporarily
  """
  @type node_type :: :not_yet_determined | :leaf | {:parent, default}
  # TODO rename enter -> entry
  @type action_type :: :enter | :exit

  use Util.GetterStruct
  getter_struct do
    field :moniker, Moniker.t
    field :transitions, Transitions.t, default: %{}
    field :type, node_type, default: :not_yet_determined
    # TODO fun needs a type
    field :actions, [{action_type, fun}], default: []
    field :autotransition, nil | Moniker.t, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Moniker.t) :: t
  def new(moniker), do: %__MODULE__{moniker: moniker}

  # *** *******************************
  # *** REDUCERS

  @spec put_transition(t, Event.t, Moniker.t) :: t
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

  def mark_as_parent(%__MODULE__{} = node), do: %__MODULE__{node | type: {:parent, nil}}

  def mark_as_leaf_if_not_parent(%__MODULE__{} = node) do
    fun = fn
      {:parent, _} = type -> type
      _ -> :leaf
    end
    Map.update!(node, :type, fun)
  end

  # TODO is this still used?
  def put_action(%__MODULE__{} = node, action_type, fun) do
    Map.update!(node, :actions, &[{action_type, fun} | &1])
  end

  def put_enter_action(%__MODULE__{} = node, fun) do
    Map.update!(node, :actions, &[{:enter, fun} | &1])
  end

  def put_exit_action(%__MODULE__{} = node, fun) do
    Map.update!(node, :actions, &[{:exit, fun} | &1])
  end

  def put_autotransition(%__MODULE__{autotransition: nil} = node, moniker) do
    %__MODULE__{node | autotransition: moniker}
  end

  def put_autotransition(%__MODULE__{autotransition: autotransition} = node, _moniker) do
    raise "#{moniker(node) |> inspect} node already has the autotransition #{autotransition}"
  end

  # *** *******************************
  # *** CONVERTERS

  @spec destination_moniker(t, Event.t) :: Moniker.t | Moniker.Self.t
  def destination_moniker(%__MODULE__{transitions: transitions}, event) do
    case transitions[event] do
      nil -> Moniker.Self.new()
      %Moniker{} = node -> node
    end
  end

  def local_name(node) do
    node
    |> moniker
    |> Moniker.local_name
  end

  def fetch_autotransition(%__MODULE__{autotransition: autotransition}) do
    if autotransition do
      {:ok, autotransition}
    else
      :none
    end
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Statechart.Node.State, as: StateNode

defimpl Statechart.Node.Protocol, for: StateNode do
  alias Statechart.Node.Moniker
  # CONVERTERS
  def moniker(node), do: StateNode.moniker(node)
  def next_default!(%StateNode{type: {:parent, %Moniker{} = value}}), do: value
  def next_default!(%StateNode{type: :leaf}), do: Moniker.Self.new()
  def enter_actions(%StateNode{actions: actions}) do
    Enum.map(actions, fn {_, action} -> action end)
  end
  def exit_actions(%StateNode{}) do
    []
  end
end

defimpl Statechart.Render.Protocol, for: StateNode do
  alias Statechart.Node
  alias Statechart.Node.Moniker
  def render(node, statechart) do
    name = Node.local_name_as_atom(node)
    actions =
      node
      |> StateNode.actions
      |> Enum.map(fn {type, fun} ->
        type =
          case type do
            :enter -> :entry
            type -> type
          end
        %{
          type: type,
          body: fun
        }
      end)
    state =
      name
      |> statechart.new_state.()
      |> Map.put(:actions, actions)
    event_transitions =
      node
      |> StateNode.transitions
      |> Enum.map(fn {event, to} ->
        # statechart.new_transition(name, to, event)
        event_string =
          event
          |> Atom.to_string
          |> String.split(".")
          |> List.last
          |> String.to_atom
        %{
          from: name,
          to: Moniker.local_name_as_atom(to),
          event: event_string,
          label: event_string
        }
      end)
    ancestor_list = Node.ancestors_as_atom_list(node)
    # TODO this is the same as in Decision Node
    maybe_put_initial =
      fn statechart ->
        case Node.next_default!(node) do
          %Moniker{} = moniker ->
            to = Moniker.local_name_as_atom(moniker)
            statechart.put_initial.(statechart, name, ancestor_list, to)
          _ ->
            statechart
        end
      end
    maybe_put_autotransition =
      fn statechart ->
        case StateNode.autotransition(node) do
          nil ->
            statechart
          moniker ->
            transition =
              %{
                from: name,
                to: Moniker.local_name_as_atom(moniker),
                label: "[auto]"
              }
            statechart.put_transitions.(statechart, [transition])
        end
      end
    statechart
    |> statechart.put_state.(state, ancestor_list)
    |> statechart.put_transitions.(event_transitions)
    |> maybe_put_initial.()
    |> maybe_put_autotransition.()
  end
end
