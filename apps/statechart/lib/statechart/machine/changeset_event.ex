defmodule Statechart.Machine.Changeset.Event do
  @moduledoc """
  Handles the logic for processing an incoming event.

  Checks that the event is valid given the current state.
  If valid, provides callbacks for updating state.
  """

  alias Statechart.Event
  alias Statechart.Event.Protocol, as: EventProtocol
  alias Statechart.Machine.Spec
  alias Statechart.Machine.Changeset.Protocol, as: Changeset
  alias Statechart.Type.Context
  alias Statechart.Node.Moniker
  alias Statechart.Node.State, as: StateNode
  alias Statechart.Node.Collection, as: NodeCollection
  alias Statechart.Node.Moniker.Self

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :get_spec, Spec.getter
    field :origin_node_name, Moniker.t
    field :event, Event.t
    field :followup, Changeset.followup_task, enforce: false
    field :message, String.t, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Moniker.t, Context.t, Event.t, Spec.getter) :: t
  def new(%Moniker{} = node_name, context, event, get_spec) do
    %__MODULE__{
      get_spec: get_spec,
      origin_node_name: node_name,
      event: event
    }
    |> check_valid_event(node_name)
    |> maybe_check_guard(context)
    |> maybe_set_decision_function
  end

  # *** *******************************
  # *** REDUCERS (private)

  defp check_valid_event(%__MODULE__{event: event} = changeset, origin_moniker) do
    get_destination_moniker =
      fn moniker ->
        changeset
        |> fetch_node!(moniker)
        |> StateNode.destination_moniker(Event.to_atom(event))
      end
    valid? =
      fn
        %Moniker{} -> true
        _ -> false
      end
    origin_moniker
    |> Moniker.unfold_up
    |> Stream.map(get_destination_moniker)
    |> Stream.filter(valid?)
    |> Enum.take(1)
    |> List.first
    |> case do
      nil ->
        changeset
        |> put_followup(:await_event)
        |> put_message("Invalid event")
      destination_moniker ->
        changeset
        |> put_followup({:goto, destination_moniker})
    end
  end

  @spec put_followup(t, Changeset.followup_task) :: t
  defp put_followup(%__MODULE__{} = changeset, followup) do
    %__MODULE__{changeset | followup: followup}
  end

  @spec put_message(t, String.t) :: t
  defp put_message(%__MODULE__{} = changeset, message) do
    %__MODULE__{changeset | message: message}
  end

  @spec maybe_check_guard(t, Context.t) :: t
  defp maybe_check_guard(%__MODULE__{followup: :await_event} = changeset, _context) do
    # Event was already found to be invalid. No need to run the context guard.
    changeset
  end
  defp maybe_check_guard(%__MODULE__{} = changeset, context) do
    case EventProtocol.guard(changeset.event, context) do
      :ok ->
        changeset
      {:error, reason} ->
        changeset
        |> put_followup(:await_event)
        |> put_message(reason)
    end
  end

  @spec maybe_set_decision_function(t) :: t
  defp maybe_set_decision_function(%__MODULE__{followup: :await_event} = changeset), do: changeset
  defp maybe_set_decision_function(%__MODULE__{followup: {:goto, destination_moniker}, event: event} = changeset) do
    if EventProtocol.has_post_guard?(event) do
      fun =
        fn context ->
          case EventProtocol.post_guard(event, context) do
            :ok -> true
            {:error, _reason} -> false
          end
        end
      goto_if_true = destination_moniker
      goto_if_false = Self.new()
      changeset
      |> put_followup({:event_post_guard, fun, goto_if_true, goto_if_false})
    else
      changeset
    end

  end

  # *** *******************************
  # *** CONVERTERS

  @spec get_action(t) :: nil | (Context.t -> Context.t)
  def get_action(%__MODULE__{followup: :await_event}), do: nil
  def get_action(%__MODULE__{} = changeset) do
    fn context ->
      EventProtocol.action(changeset.event, context)
    end
  end

  # *** *******************************
  # *** CONVERTERS (private)

  defp fetch_node!(%__MODULE__{get_spec: getter}, node_name) do
    %Spec{} = spec = getter.()
    spec
    |> Spec.nodes
    |> NodeCollection.get_node(node_name)
    |> tap(& unless &1, do: raise "node not found")
  end

end

# *** *********************************
# *** IMPLEMENTATIONS

alias Statechart.Machine.Changeset.Event, as: EventChangeset

defimpl Statechart.Machine.Changeset.Protocol, for: EventChangeset do
  alias Statechart.Node.Stay
  def actions(changeset), do: changeset |> EventChangeset.get_action |> List.wrap
  def followup(changeset), do: EventChangeset.followup(changeset)
  def next_moniker(_changeset), do: Stay.new()
end

defimpl Inspect, for: EventChangeset do
  # import Inspect.Algebra
  require IOP
  def inspect(%EventChangeset{} = changeset, opts) do
    summary =
      [
        "🌱": changeset.origin_node_name,
        "💥": changeset.event
      ]
    fields = [
      node_and_event: summary,
      message: changeset.message,
      followup: changeset.followup
    ]
    IOP.struct("EventChangeset", fields)
  end
end

