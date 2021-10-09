defmodule Statechart.Machine.Changeset.Goto do
  @moduledoc """
  A changeset fully describing a single transition from one node to another

  An initial transition is created by incoming event. (node A -> node B)
  We follow the "chain of defaults" from node B down to e.g. node C.
  At this point, the changeset is locked in, and we're at one of several options:
  - A state-leaf node
    - with auto-transition, with will trigger another Changeset round, or
    - no auto-transition. Machine goes back into "awaiting Event" mode
  - A state-parent node - raise exception (for now at least,
    maybe later autotransitions will be allowed.)
  - A decision node.
    This will trigger another Changeset.
  Node A is the FROM-node and C the TO-node.

  This is then used to change the state of a machine:
  - update current state to "TO node"
  - execute exit actions, one by one
  - execute enter actions, one by one

  Example

  FROM node: #Node<root/on/green>
  initial TO node: #Node<root/blinking>
  #Node<root/blinking> has a default of :yellow, which is a leaf node
  So, the final TO node is #Node<root/blinking/yellow>
  When this Changeset is executed, these are the on-_____ actions
  that will be executed in order:
  - green: on_exit
  - on: on_exit
  - blinking: on_enter
  - yellow: on_enter
  So you can see, we go up the exit chain and down the enter chain.

  Note, the Event's action was executed before we even got to the Changeset.
  The Changeset is generated only after an event...
  - is determined to be valid wrt the state machine,
  - is determined to be valid wrt the context,
  - its action executed
  - its post-guard returns true
  Only NOW is the Changeset kicked off, now that we know we
  are *actually* leaving the FROM node.
  """

  alias Statechart.Machine.Spec
  alias Statechart.Machine.Changeset.Protocol
  alias Statechart.Node
  alias Statechart.Node.Moniker
  alias Statechart.Node.Collection, as: NodeCollection
  alias Statechart.Node.State, as: StateNode
  alias Statechart.Node.Decision, as: DecisionNode

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :spec_getter, Spec.getter
    field :origin_node_name, Moniker.t
    field :destination_node_name, Moniker.t # This is the "given" destination. The final node name (after following the defaults chain)
    field :terminating_node_name, Moniker.t, enforce: false
    field :transition_steps, [{:start | :up | :down, Moniker.t}], default: []
    field :followup, Protocol.followup_task, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Moniker.t, Moniker.t, Spec.getter) :: t
  def new(%Moniker{} = from_node, %Moniker{} = to_node, spec_getter) do
    %__MODULE__{
      spec_getter: spec_getter,
      origin_node_name: from_node,
      destination_node_name: to_node
    }
    |> follow_defaults_chain(to_node)
    |> set_transition_steps
    |> determine_followup_mode
  end

  # *** *******************************
  # *** REDUCERS (private)

  defp follow_defaults_chain(%__MODULE__{} = changeset, node_name) do
    changeset
    |> fetch_node!(node_name)
    |> Node.next_default!
    |> case do
      %Moniker{} = moniker ->
        follow_defaults_chain(changeset, moniker)
      %Moniker.Self{} ->
        %__MODULE__{changeset | terminating_node_name: node_name}
    end
  end

  defp set_transition_steps(%__MODULE__{origin_node_name: %Moniker{} = from, terminating_node_name: %Moniker{} = to} = changeset) do
    %__MODULE__{changeset | transition_steps: Moniker.transition_steps(from, to)}
  end

  defp determine_followup_mode(%__MODULE__{terminating_node_name: node_name, transition_steps: steps} = changeset) do
    followup =
      changeset
      |> fetch_node!(node_name)
      |> case do
        %DecisionNode{} = node ->
          {:decision_node, node.fun, node.goto_if_true, node.goto_if_false}
        %StateNode{} ->
          steps
          |> Stream.filter(fn {direction, _} -> direction == :down end)
          |> Stream.map(fn {_, node_name} -> node_name end)
          |> Enum.reverse # so that we're starting with the terminating and working back up
          |> Stream.map(&fetch_node!(changeset, &1))
          |> Stream.map(&Node.get_autotransition/1)
          |> Stream.reject(&is_nil/1)
          |> Enum.take(1)
          |> case do
            [] ->
              :await_event
            [%Moniker{} = autotransition_destination] ->
              {:goto, autotransition_destination}
          end
      end
    %__MODULE__{changeset | followup: followup}
  end

  # *** *******************************
  # *** CONVERTERS

  def exit_and_enter_actions(%__MODULE__{transition_steps: steps} = changeset) do
    callback =
      fn
        :up ->
          &Node.exit_actions/1
        :down ->
          &Node.enter_actions/1
        _ ->
          fn _ -> [] end
      end
    get_actions =
      fn {direction, %Moniker{} = node_name} ->
        changeset
        |> fetch_node!(node_name)
        |> callback.(direction).()
      end
    Enum.flat_map(steps, get_actions)
  end

  # *** *******************************
  # *** CONVERTERS (private)

  defp fetch_node!(%__MODULE__{spec_getter: getter}, node_name) do
    %Spec{} = spec = getter.()
    spec
    |> Spec.nodes
    |> NodeCollection.get_node(node_name)
    |> tap(& unless &1, do: raise "node not found")
  end

end

# *** *********************************
# *** IMPLEMENTATIONS

alias Statechart.Machine.Changeset.Goto, as: GotoChangeset

defimpl Statechart.Machine.Changeset.Protocol, for: GotoChangeset do
  def actions(changeset), do: GotoChangeset.exit_and_enter_actions(changeset)
  def followup(changeset), do: GotoChangeset.followup(changeset)
  def next_moniker(changeset), do: GotoChangeset.terminating_node_name(changeset)
end

defimpl Inspect, for: GotoChangeset do
  # import Inspect.Algebra
  require IOP
  def inspect(%GotoChangeset{} = changeset, opts) do
    summary =
      cond do
        changeset.origin_node_name == changeset.destination_node_name ->
          [
            "🌱🎯": changeset.origin_node_name,
            "⤵️ ": changeset.terminating_node_name
          ]
        changeset.destination_node_name == changeset.terminating_node_name ->
          [
            "🌱": changeset.origin_node_name,
            "🎯⤵️ ": changeset.destination_node_name
          ]
        true ->
          [
            "🌱": changeset.origin_node_name,
            "🎯": changeset.destination_node_name,
            "⤵️ ": changeset.terminating_node_name
          ]
      end
    fields = [
      summary: summary,
      transition_steps: changeset.transition_steps,
      followup: changeset.followup
    ]
    IOP.struct("GotoChangeset", fields)
  end
end
