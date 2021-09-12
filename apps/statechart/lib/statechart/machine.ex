defmodule Statechart.Machine do

  alias Statechart.Event.Protocol, as: EventProtocol
  alias Statechart.Machine.Spec
  alias Statechart.Type.Event
  alias Statechart.Type.NodeName
  alias Statechart.Type.Node
  alias Statechart.Type.Nodes

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    # TODO rename last_event_status
    field :transition_status, :ok | {:error, reason :: String.t}, default: :ok
    field :spec_module, module
    field :current_node_name, NodeName.t
    field :context, Context.t, enforce: false
    # TODO remove
    field :last_event, any, enforce: false
    field :latest_acc, map, default: %{}
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def from_spec(spec_module) when is_atom(spec_module) do
    spec = get_spec(spec_module)
    %__MODULE__{
      spec_module: spec_module,
      current_node_name: Spec.initial_node_name(spec),
      context: Spec.context(spec)
    }
  end

  # *** *******************************
  # *** REDUCERS

  @spec transition(t, Event.t) :: t
  def transition(machine, event) do
    check_valid_event(machine, %{event: event})
  end

  @deprecated "use get_context/1 instead"
  def fetch_context!(%__MODULE__{context: value}), do: value

  def get_context(%__MODULE__{context: value}), do: value

  # TODO move these to the Helpers module
  @deprecated "use Statechart.Helpers functions instead"
  def print_status(machine) do
    machine
    |> status
    |> IOP.inspect(__MODULE__)
    machine
  end

  @deprecated "use Statechart.Helpers functions instead"
  def print_no_context(machine) do
    IOP.inspect %__MODULE__{machine | context: :not_printed}
    machine
  end

  @deprecated "use Statechart.Helpers functions instead"
  def print_spec(machine) do
    IOP.inspect spec(machine), __MODULE__
    machine
  end

  # *** *******************************
  # *** REDUCERS (mini state machine for processing transition/1)

  defp check_valid_event(machine, %{event: event} = acc) do
    spec = spec(machine)
    current_node_name = current_node_name(machine)
    event_atom = Event.to_atom(event)
    case Spec.fetch_next_state(spec, current_node_name, event_atom) do
      {:ok, next_node_name} ->
        check_guard(machine, Map.put(acc, :next_node_name, next_node_name))
      {:error, reason} ->
        machine
        |> set_latest_acc(acc)
        |> put_error_status(reason)
    end
  end

  defp check_guard(%__MODULE__{context: context} = machine, %{event: event} = acc) do
    case EventProtocol.guard(event, context) do
      :ok ->
        apply_action(machine, acc)
      {:error, reason} ->
        machine
        |> set_latest_acc(acc)
        |> put_error_status(reason)
    end
  end

  defp apply_action(%__MODULE__{context: context} = machine, %{event: event} = acc) do
    case EventProtocol.action(event, context) do
      {:ok, next_context} ->
        machine
        |> put_context(next_context)
        |> check_post_guard(acc)
    end
  end

  # TODO rename acc to `acc`?
  defp check_post_guard(%__MODULE__{context: context} = machine, %{event: event} = acc) do
    case EventProtocol.post_guard(event, context) do
      :ok ->
        machine
        |> go_to_next_node(acc)
      # TODO this should be an error instead I think...
      :stay ->
        machine
        |> set_latest_acc(acc)
        |> put_stay_status
    end
  end

  defp go_to_next_node(%__MODULE__{} = machine, %{next_node_name: next_node_name} = acc) do
    machine
    |> put_current_node_name(next_node_name)
    |> apply_on_enter_actions(acc)
  end

  defp apply_on_enter_actions(%__MODULE__{} = machine, %{} = acc) do
    update_context_funs =
      Spec.on_enter_actions(
        spec(machine),
        node_name(machine)
      )
    machine = Enum.reduce(update_context_funs, machine, &update_context(&2, &1))
    check_autotransition(machine, acc)
  end

  defp check_autotransition(%__MODULE__{} = machine, %{} = acc) do
    case machine |> current_node |> Node.fetch_autotransition do
      {:ok, next_node_name} ->
        machine
        |> put_current_node_name(next_node_name)
        |> apply_on_enter_actions(acc)
      :none ->
        machine
        |> put_ok_status
        |> set_latest_acc(acc)
    end
  end

  # *** *******************************
  # *** REDUCERS (private)

  defp set_latest_acc(machine, acc) do
    %__MODULE__{machine | latest_acc: acc}
  end

  # Need guard - non-empty list
  defp put_current_node_name(machine, state) do
    %__MODULE__{machine | current_node_name: state}
  end

  defp put_context(machine, context) do
    %__MODULE__{machine | context: context}
  end

  defp put_ok_status(machine) do
    %__MODULE__{machine | transition_status: :ok}
  end

  defp put_stay_status(machine) do
    %__MODULE__{machine | transition_status: :stay}
  end

  defp put_error_status(machine, reason) do
    %__MODULE__{machine | transition_status: {:error, reason}}
  end

  defp update_context(%__MODULE__{context: context} = machine, fun) do
    %__MODULE__{machine | context: fun.(context)}
  end

  # *** *******************************
  # *** CONVERTERS

  def spec(%__MODULE__{spec_module: module}) do
    get_spec(module)
  end

  def in?(machine, node_name) do
    machine
    |> current_node_name
    |> NodeName.in?(node_name)
  end

  @deprecated "Use current_node_name/1 instead."
  def state(%__MODULE__{current_node_name: value}), do: value

  @deprecated "use current_node_name/1 instead"
  def node_name(%__MODULE__{current_node_name: value}), do: value

  @deprecated "Use current_node_name/1 instead."
  def current_state(machine) do
    current_node_name(machine)
  end

  # *** *******************************
  # *** CONVERTERS (private)

  defp status(%__MODULE__{transition_status: value}), do: value

  defp current_node(%__MODULE__{} = machine) do
    machine
    |> spec
    |> Spec.nodes
    |> Nodes.get_node(machine |> current_node_name)
  end

  # *** *******************************
  # *** HELPERS

  defp get_spec(module) do
    %Spec{} = spec = apply(module, :get_def, [])
    spec
  end

end
