defmodule Statechart.Machine do

  alias Statechart.Event
  alias Statechart.Machine.Changeset.Goto, as: GotoChangeset
  alias Statechart.Machine.Changeset.Protocol, as: Changeset
  alias Statechart.Machine.Changeset.Event, as: EventChangeset
  alias Statechart.Machine.Changeset.Decision, as: DecisionChangeset
  alias Statechart.Machine.Spec
  alias Statechart.Node.Moniker
  # TODO Replace Stay with using Self?
  alias Statechart.Node.Stay
  alias Statechart.Type.Context

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :get_spec, (-> Spec.t)
    field :node_name, Moniker.t
    field :context, Context.t, enforce: false
    field :changesets, [Changeset.t], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_spec(spec_module) when is_atom(spec_module) do
    get_spec = fn -> %Spec{} = apply(spec_module, :fetch_spec!, []) end
    %__MODULE__{
      get_spec: get_spec,
      node_name: Moniker.new_root(),
      context: get_spec.() |> Spec.context
    }
    |> goto(Moniker.new_root())
  end

  # *** *******************************
  # *** REDUCERS

  @spec transition(t, Event.t) :: t
  def transition(machine, event) do
    changeset =
      EventChangeset.new(
        node_name(machine),
        context(machine),
        event,
        get_spec(machine)
      )
    apply_changeset(machine, changeset)
  end

  # *** *******************************
  # *** REDUCERS (private)

  defp apply_changeset(machine, changeset) do
    new_machine = nore_apply_changeset(machine, changeset)
    case Changeset.followup(changeset) do
      :await_event ->
        new_machine
      {task_symbol, _, _, _} = followup_task when task_symbol in ~w/event_post_guard decision_node/a ->
        changeset = DecisionChangeset.new(followup_task, context(new_machine))
        apply_changeset(new_machine, changeset)
      {:goto, %Moniker{} = destination_node_name} ->
        goto(new_machine, destination_node_name)
    end
  end

  @spec goto(t, Moniker.t) :: t
  defp goto(%__MODULE__{} = machine, %Moniker{} = node_name) do
    changeset = changeset(machine, node_name)
    apply_changeset(machine, changeset)
  end

  @spec nore_apply_changeset(t, Changeset.t) :: t
  defp nore_apply_changeset(%__MODULE__{context: context} = machine, changeset) do
    context =
      changeset
      |> Changeset.actions
      |> Enum.reduce(context, & &1.(&2))
    machine
    |> put_node_name(changeset |> Changeset.next_moniker)
    |> put_context(context)
    |> put_changeset(changeset)
  end

  # *** *******************************
  # *** REDUCERS (private)

  defp put_node_name(machine, %Stay{}), do: machine
  defp put_node_name(machine, %Moniker{} = node_name) do
    %__MODULE__{machine | node_name: node_name}
  end

  defp put_context(machine, context) do
    %__MODULE__{machine | context: context}
  end

  @spec put_changeset(t, Changeset.t) :: t
  defp put_changeset(%__MODULE__{} = machine, %EventChangeset{} = changeset) do
    # For now, I don't care what happened before the last event.
    # Usually when things break, they break during and because of a single event
    %__MODULE__{machine | changesets: [changeset]}
  end
  defp put_changeset(%__MODULE__{changesets: changesets} = machine, changeset) do
    %__MODULE__{machine | changesets: [changeset | changesets]}
  end

  # *** *******************************
  # *** CONVERTERS

  def spec(%__MODULE__{get_spec: get_spec}), do: get_spec.()

  def in?(machine, node_name) do
    machine
    |> current_node_name
    |> Moniker.contains?(node_name)
  end

  @deprecated "Use node_name/1 instead."
  def current_node_name(%__MODULE__{node_name: val}), do: val

  def at_root(machine) do
    1 ===
      machine
      |> current_node_name
      |> Moniker.depth
  end

  # *** *******************************
  # *** CONVERTERS (private)

  defp changeset(
    %__MODULE__{node_name: %Moniker{} = from} = machine,
    %Moniker{} = to
  ) do
    get_spec = fn -> spec(machine) end
    GotoChangeset.new(from, to, get_spec)
  end

end
