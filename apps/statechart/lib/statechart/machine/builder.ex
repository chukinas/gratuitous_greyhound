# TODO the root should be allowed an on_enter_action
# TODO the root should be allowed an autotransition

defmodule Statechart.Machine.Builder do
  @moduledoc """
  A behavior that ensures a modules has a function for returning a Machine
  """

  alias Statechart.Machine
  alias Statechart.Machine.Spec
  alias Statechart.Machine.Builder.Helpers
  alias Statechart.Node.Moniker
  alias Statechart.Machine.Builder.StateInput
  alias Statechart.Node
  alias Statechart.Node.LocalName.Collection, as: LocalNameCollection
  alias Statechart.Node.Decision, as: DecisionNode
  alias Statechart.Node.Collection, as: NodeCollection
  alias Statechart.Node.State, as: StateNode
  require StateInput

  @callback fetch_spec!() :: Spec.t
  @callback new() :: Machine.t

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      require unquote(__MODULE__)
      import unquote(__MODULE__)
      require Statechart.Machine.Builder.Helpers
    end
  end

  defmacro defmachine(do: block) do
    quote do

      @__current_moniker__ Moniker.root()
      @__nodes__ NodeCollection.new_with_root()

      @__build_step__ :accumulate_monikers
      Module.register_attribute(__MODULE__, :__monikers__, accumulate: true)
      unquote(block)
      @__local_names__ LocalNameCollection.from_monikers(@__monikers__)
      Module.delete_attribute(__MODULE__, :__monikers__)

      @__build_step__ :create_decision_nodes
      unquote(block)

      @__build_step__ :create_state_nodes
      unquote(block)
      Helpers.eval_leaves_and_parents()

      @__build_step__ :update_state_nodes
      @__context__ nil
      # TODO this build step name doesn't match the fact that context is assigned at this step
      unquote(block)

      @__build_step__ :validate_nodes
      unquote(block)

      @__spec__ Spec.new(__MODULE__, @__context__, @__local_names__, @__nodes__)
      Module.delete_attribute(__MODULE__, :__context__)
      Module.delete_attribute(__MODULE__, :__local_names__)
      Module.delete_attribute(__MODULE__, :__nodes__)
      Module.delete_attribute(__MODULE__, :__build_step__)
      Module.delete_attribute(__MODULE__, :__current_moniker__)

      @impl unquote(__MODULE__)
      @spec fetch_spec! :: Spec.t
      def fetch_spec!, do: @__spec__

      @impl unquote(__MODULE__)
      @spec new :: Machine.t
      def new do
        Machine.from_spec(__MODULE__)
      end

      defdelegate transition(machine, event), to: Machine

      Module.delete_attribute(__MODULE__, :__spec__)
    end
  end

  defmacro default_to(local_name) when is_atom(local_name) do
    quote do
      if @__build_step__ === :update_state_nodes do
        Helpers.set_default(unquote(local_name))
      end
    end
  end

  defmacro defstate(local_name) when is_atom(local_name) do
    quote do
      defstate unquote(local_name), do: nil
    end
  end

  defmacro defstate(local_name, opts \\ [], do: block) when is_atom(local_name) do
    quote do
      moniker = unquote(local_name)
      if @__build_step__ === :update_state_nodes && unquote(opts[:default]) do
        Helpers.set_default(moniker)
      end
      Helpers.down_moniker(moniker)
      case @__build_step__ do
        :accumulate_monikers ->
          @__monikers__ @__current_moniker__
        :create_state_nodes ->
          @__current_moniker__
          |> StateNode.new
          |> Helpers.put_new_node!
        :validate_nodes ->
          case Helpers.fetch_current_node!() |> Node.check_valid do
            {:error, reason} ->
              raise reason
            :ok ->
              :ok
          end
        _ ->
          nil
      end
      unquote(block)
      Helpers.up_moniker()
    end
  end

  defmacro decision(local_name, fun, if_true: goto_if_true, else: goto_if_false)
  #when is_function(fun)
  when is_atom(goto_if_true)
  and is_atom(goto_if_false) do
    quote do
      Helpers.down_moniker(unquote(local_name))
      case @__build_step__ do
        :accumulate_monikers ->
          @__monikers__ @__current_moniker__
        :create_decision_nodes ->
          Helpers.put_new_node! DecisionNode.new(
            @__current_moniker__,
            unquote(fun),
            Helpers.fetch_moniker!(unquote(goto_if_true)),
            Helpers.fetch_moniker!(unquote(goto_if_false))
          )
        _ -> nil
      end
      Helpers.up_moniker()
    end
  end

  defmacro on(event, do: next_state) do
    quote do
      if @__build_step__ === :update_state_nodes do
        destination_moniker = Helpers.fetch_moniker!(unquote(next_state))
        update_node = &StateNode.put_transition(&1, unquote(event), destination_moniker)
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro on_enter(fun) do
    quote do
      if @__build_step__ === :update_state_nodes do
        update_node =
          fn %StateNode{} = state_node ->
            StateNode.put_enter_action(state_node, unquote(fun))
          end
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro autotransition(local_name) when is_atom(local_name) do
    quote do
      if @__build_step__ === :update_state_nodes do
        destination_moniker = Helpers.fetch_moniker!(unquote(local_name))
        update_node = &StateNode.put_autotransition(&1, destination_moniker)
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro initial_context(context) do
    quote do
      if @__build_step__ === :update_state_nodes do
        @__context__ unquote(context)
      end
    end
  end

end
