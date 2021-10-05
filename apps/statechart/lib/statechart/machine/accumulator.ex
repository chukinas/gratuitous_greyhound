# TODO most of this accumulator is unnecessary overhead.
# I should just use accumulating attrs on the calling module instead

defmodule Statechart.Machine.Accumulator do

  use TypedStruct
  alias Statechart.Type.Context
  alias Statechart.Type.NodeName
  alias Statechart.Type.Transition

  # *** *******************************
  # *** TYPES

  typedstruct do
    field :current_state, NodeName.t, default: NodeName.root()
    field :states, [NodeName.t], default: [NodeName.root()]
    field :defaults, [{parent_node_name :: NodeName.t, default_node_name :: NodeName.t}], default: []
    field :transitions, [Transition.t], default: []
    field :context, Context.t
    field :actions, [{:update_context, NodeName.t, fun}], default: []
    field :autotransitions, [{NodeName.t, NodeName.t}], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new() :: t
  def new() do
    %__MODULE__{}
  end

  # *** *******************************
  # *** REDUCERS

  def add_depth_to_current_state(%__MODULE__{current_state: state, states: states} = acc, inner_state) do
    next_state = NodeName.add_depth(state, inner_state)
    %__MODULE__{acc |
      current_state: next_state,
      states: [next_state | states]
    }
  end

  def remove_depth_from_current_state(%__MODULE__{} = acc) do
    fun = &NodeName.decrease_depth(&1)
    Map.update!(acc, :current_state, fun)
  end

  def add_default(%{current_state: parent_node_name} = acc, default_node_name) do
    new_default = {parent_node_name, default_node_name}
    Map.update!(acc, :defaults, &[new_default | &1])
  end

  def set_init_context(acc, context) do
    %__MODULE__{acc | context: context}
  end

  def add_transition(%__MODULE__{} = acc, event, next_state)
  when is_list(next_state)
  or is_atom(next_state) do
    transition = Transition.new(acc.current_state, event, next_state)
    fun = &[transition | &1]
    Map.update!(acc, :transitions, fun)
  end

  def on_enter(%__MODULE__{} = acc, fun) do
    Map.update!(acc, :actions, &[{:update_context, acc.current_state, fun} | &1])
  end

  def autotransition(%__MODULE__{} = acc, node_name) do
    Map.update!(acc, :autotransitions, &[{acc.current_state, node_name} | &1])
  end

  # *** *******************************
  # *** CONVERTERS

  def current_state(%__MODULE__{current_state: value}), do: value

end
