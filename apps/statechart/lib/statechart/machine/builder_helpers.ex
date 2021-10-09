defmodule Statechart.Machine.Builder.Helpers do

  alias Statechart.Node.Moniker
  alias Statechart.Machine.Builder.StateInput
  alias Statechart.Node.LocalName.Collection, as: LocalNameCollection
  alias Statechart.Node.State, as: StateNode
  alias Statechart.Node.Collection, as: NodeCollection
  alias __MODULE__
  require StateInput

  defmacro down_moniker(local_name) do
    quote do
      new_moniker = Moniker.down(@__current_moniker__, unquote(local_name))
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

  defmacro fetch_moniker!(local_name) do
    quote bind_quoted: [local_name: local_name] do
      case local_name do
        local_name when is_atom(local_name) ->
          LocalNameCollection.fetch_moniker!(@__local_names__, local_name)
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

  defmacro set_default(local_name) do
    quote do
      if @__build_step__ === :update_state_nodes do
        destination_moniker = Helpers.fetch_moniker!(unquote(local_name))
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
