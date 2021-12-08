defmodule Statechart.Machine.Builder.Helpers do

  alias Statechart.Node.Moniker
  alias Statechart.Machine.Builder.StateInput
  alias Statechart.Node.LocalName.Collection, as: LocalNameCollection
  alias Statechart.Node.State, as: StateNode
  alias Statechart.Node.Collection, as: NodeCollection
  alias __MODULE__
  require StateInput
  import Statechart.Node.Id

  defmacro register_moniker(moniker) do
    quote do
      @__monikers__ unquote(moniker)
    end
  end

  # TODO can I use a guard?
  defmacro down_moniker(node_id) do
    quote do
      new_moniker = Moniker.down(@__current_moniker__, unquote(node_id))
      @__current_moniker__ new_moniker
    end
  end

  defmacro up_moniker do
    quote do
      @__current_moniker__ Moniker.up(@__current_moniker__)
    end
  end

  defmacro put_new_node!(node) do
    quote do
      @__nodes__ NodeCollection.put_new_node!(@__nodes__, unquote(node))
    end
  end

  defmacro fetch_moniker!(node_id) do
    quote bind_quoted: [node_id: node_id] do
      case node_id do
        node_id when is_valid_user_defined_id(node_id) ->
          LocalNameCollection.fetch_moniker!(@__node_ids__, node_id)
        %Moniker{} = moniker ->
          moniker
      end
    end
  end

  defmacro update_current_node!(fun) do
    quote do
      @__nodes__ NodeCollection.update_node!(@__nodes__, @__current_moniker__, unquote(fun))
    end
  end

  defmacro eval_leaves_and_parents do
    quote do
      @__nodes__ NodeCollection.identify_leaves_and_parents(@__nodes__)
    end
  end

  defmacro set_default(node_id) do
    quote do
      if @__build_step__ === :update_state_nodes_and_put_context do
        destination_moniker = Helpers.fetch_moniker!(unquote(node_id))
        update_node = &StateNode.put_default(&1, destination_moniker)
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro fetch_current_node! do
    quote do
      NodeCollection.fetch_node!(@__nodes__, @__current_moniker__)
    end
  end

end
