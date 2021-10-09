defmodule Statechart.Machine.Changeset.Decision do
  @moduledoc """
  Handles the logic for processing a decision.

  A desision results from a Changeset followup of {:decision, fun}

  A decision consists of a boolean function and two nodes we will
  travel to, depending on whether the result is true or false.

  At the time of this writing, that can be caused by:
  1) A DecisionNode
  2) The post-guard check of an Event.Protocol implementation
     (though I hope to short-circuit non-overrides)
  """

  alias __MODULE__, as: DecisionChangeset
  alias Statechart.Type.Context
  alias Statechart.Node.Moniker
  alias Statechart.Node.Moniker.Self
  alias Statechart.Machine.Changeset.Protocol, as: ChangesetProtocol

  # *** *******************************
  # *** TYPES

  @type fun :: (Context.t -> boolean)
  @type source :: :decision_node | :event_post_guard

  use Util.GetterStruct
  getter_struct do
    field :_source, source
    field :goto_if_true, Moniker.destination
    field :goto_if_false, Moniker.destination
    field :followup, ChangesetProtocol.followup_task
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new({source, fun, Moniker.destination, Moniker.destination}, Context.t) :: t
  def new({task_symbol, fun, goto_if_true, goto_if_false}, context) do
    destination_moniker = if fun.(context), do: goto_if_true, else: goto_if_false
    followup =
      case {task_symbol, destination_moniker} do
        {_, %Moniker{} = next_moniker} -> {:goto, next_moniker}
        {:event_post_guard, %Self{}} -> :await_event
      end
    %__MODULE__{
      _source: task_symbol,
      goto_if_true: goto_if_true,
      goto_if_false: goto_if_false,
      followup: followup
    }
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Statechart.Machine.Changeset.Decision, as: DecisionChangeset
alias Statechart.Machine.Changeset.Protocol, as: ChangesetProtocol
alias Statechart.Node.Stay

defimpl ChangesetProtocol, for: DecisionChangeset do
  def actions(_changeset), do: []
  def followup(changeset), do: DecisionChangeset.followup(changeset)
  def next_moniker(_changeset), do: Stay.new()
end

defimpl Inspect, for: DecisionChangeset do
  # import Inspect.Algebra
  require IOP
  def inspect(%DecisionChangeset{} = changeset, opts) do
    fields =
      [
        "👍": changeset.goto_if_true,
        "👎": changeset.goto_if_false,
        followup: changeset.followup
      ]
    IOP.struct("DecisionChangeset", fields)
  end
end
