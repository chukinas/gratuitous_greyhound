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

alias Statechart.Node.Decision, as: Node

defimpl Statechart.Node.Protocol, for: Node do
  alias Statechart.Node.Moniker.Self
  # CONVERTERS
  def moniker(node), do: Node.moniker(node)
  def next_default!(_), do: Self.new()
  def enter_actions(_), do: []
  def exit_actions(_), do: []
end
