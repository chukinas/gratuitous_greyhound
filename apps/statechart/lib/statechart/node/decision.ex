defmodule Statechart.Node.Decision do

  alias Statechart.Node.Moniker
  alias Statechart.Type.Context

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :moniker, Moniker.t
    field :fun, Context.t
    field :goto_if_true, Moniker.destination
    field :goto_if_false, Moniker.destination
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(moniker, fun, goto_if_true, goto_if_false) do
    %__MODULE__{
      moniker: moniker,
      fun: fun,
      goto_if_true: goto_if_true,
      goto_if_false: goto_if_false
    }
  end

  # *** *******************************
  # *** REDUCERS

  def put_destination_monikers(node, %Moniker{} = goto_if_true, %Moniker{} = goto_if_false) do
    %__MODULE__{node | goto_if_true: goto_if_true, goto_if_false: goto_if_false}
  end

  # *** *******************************
  # *** CONVERTERS

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Statechart.Node.Decision, as: DecisionNode

defimpl Statechart.Node.Protocol, for: DecisionNode do
  alias Statechart.Node.Moniker.Self
  # CONVERTERS
  def moniker(node), do: DecisionNode.moniker(node)
  def next_default!(_), do: Self.new()
  def enter_actions(_), do: []
  def exit_actions(_), do: []
end

defimpl Statechart.Render.Protocol, for: DecisionNode do
  alias Statechart.Node
  alias Statechart.Node.Moniker
  def render(%DecisionNode{} = node, statechart) do
    name = Node.local_name_as_atom(node)
    state =
      %{
        name: name,
        type: :choice,
        actions: [%{
          type: :activity,
          body: name
        }]
      }
    transitions = [
      %{
        from: name,
        to: Moniker.local_name_as_atom(node.goto_if_true),
        label: "[yes]",
        cond: :yes
      },
      %{
        from: name,
        to: Moniker.local_name_as_atom(node.goto_if_false),
        label: "[no]",
        cond: :no
      }
    ]
    ancestor_list = Node.ancestors_as_atom_list(node)
        # TODO this is the same as in StateNode
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
    statechart
    |> statechart.put_state.(state, ancestor_list)
    |> statechart.put_transitions.(transitions)
    |> maybe_put_initial.()
  end
end
