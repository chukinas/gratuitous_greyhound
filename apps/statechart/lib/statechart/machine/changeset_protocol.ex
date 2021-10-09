defprotocol Statechart.Machine.Changeset.Protocol do
  @moduledoc """
  """

  alias Statechart.Node.Moniker
  alias Statechart.Node.Stay
  alias Statechart.Type.Context

  @type decision_fun :: (Context.t -> boolean)

  @type followup_task ::
  :await_event |
  {:decision_node | :event_post_guard, decision_fun, Moniker.destination, Moniker.destination} |
  {:goto, Moniker.t}

  @spec actions(t) :: [(Context.t -> Context.t)]
  def actions(changeset)

  @spec followup(t) :: followup_task
  def followup(changeset)

  @spec next_moniker(t) :: Moniker.t | Stay.t
  def next_moniker(changeset)

end
