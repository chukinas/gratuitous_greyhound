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
  import Statechart.Node.Id

  @callback fetch_spec!() :: Spec.t
  @callback new() :: Machine.t

  @typedoc """
  Valid keys:
  - `:external_states` - list of `name`s
  """
  @type machine_opts :: keyword()

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      require unquote(__MODULE__)
      import unquote(__MODULE__)
      require Statechart.Machine.Builder.Helpers
    end
  end

  @spec defmachine(machine_opts, any) :: any
  defmacro defmachine(opts \\ [], do_block)
  defmacro defmachine(opts, do: block) do

    macro_escaped_block = Macro.escape(block)

    quote do
      opts = unquote(opts)
      external_state_names =
        opts
        |> Keyword.get(:external_states, [])
        |> case do
          [] -> []
          names -> [nil | names]
        end
        |> Enum.uniq
      partial_machine? = not Enum.empty?(external_state_names)

      @__current_moniker__ Moniker.new_root()
      @__nodes__ NodeCollection.new_with_root()

      @__build_step__ :build_local_name_collection
      Module.register_attribute(__MODULE__, :__monikers__, accumulate: true)
      for name <- external_state_names do
        moniker = Moniker.new_external(name)
        Helpers.register_moniker(moniker)
      end
      unquote(block)
      @__node_ids__ LocalNameCollection.from_monikers(@__monikers__)
      Module.delete_attribute(__MODULE__, :__monikers__)

      @__build_step__ :create_decision_nodes
      unquote(block)

      @__build_step__ :create_state_nodes
      for name <- external_state_names do
        name
        |> Moniker.new_external
        |> StateNode.new
        |> Helpers.put_new_node!
      end
      unquote(block)
      Helpers.eval_leaves_and_parents()

      @__build_step__ :update_state_nodes_and_put_context
      @__context__ nil
      unquote(block)

      @__build_step__ :validate_nodes
      unquote(block)

      @__spec__ Spec.new(__MODULE__, @__context__, @__node_ids__, @__nodes__)
      Module.delete_attribute(__MODULE__, :__context__)
      Module.delete_attribute(__MODULE__, :__node_ids__)
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

      def get_ast do
        unquote(macro_escaped_block)
      end

    end
  end

  @doc """
  Insert a partial machine into a parent machine.

  `module` is one in which a `defmachine/2` call was made.
  """
  defmacro defpartial(name, module, opts \\ []) do
    expanded_module = Macro.expand(module, __CALLER__)
    ast = expanded_module.get_ast()
    quote do
      defstate(unquote(name), unquote(opts)) do
        unquote(ast)
      end
    end
  end

  defmacro default_to(node_id) when is_valid_user_defined_id(node_id) do
    quote do
      if @__build_step__ === :update_state_nodes_and_put_context do
        Helpers.set_default(unquote(node_id))
      end
    end
  end

  defmacro defstate(node_id) when is_valid_user_defined_id(node_id) do
    quote do
      defstate unquote(node_id), do: nil
    end
  end

  defmacro defstate(node_id, opts \\ [], do: block) when is_atom(node_id) do
    quote do
      name = unquote(node_id)
      if @__build_step__ === :update_state_nodes_and_put_context && unquote(opts[:default]) do
        Helpers.set_default(name)
      end
      Helpers.down_moniker(name)
      case @__build_step__ do
        :build_local_name_collection ->
          Helpers.register_moniker @__current_moniker__
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

  defmacro decision(node_id, fun, if_true: goto_if_true, else: goto_if_false)
  #when is_function(fun)
  when is_atom(goto_if_true)
  and is_atom(goto_if_false) do
    quote do
      Helpers.down_moniker(unquote(node_id))
      case @__build_step__ do
        :build_local_name_collection ->
          Helpers.register_moniker @__current_moniker__
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
      if @__build_step__ === :update_state_nodes_and_put_context do
        destination_moniker = Helpers.fetch_moniker!(unquote(next_state))
        update_node = &StateNode.put_transition(&1, unquote(event), destination_moniker)
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro on_enter(fun) do
    quote do
      if @__build_step__ === :update_state_nodes_and_put_context do
        update_node =
          fn %StateNode{} = state_node ->
            StateNode.put_enter_action(state_node, unquote(fun))
          end
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro on_exit(fun) do
    quote do
      if @__build_step__ === :update_state_nodes_and_put_context do
        update_node =
          fn %StateNode{} = state_node ->
            StateNode.put_exit_action(state_node, unquote(fun))
          end
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro autotransition(node_id) when is_valid_user_defined_id(node_id) do
    quote do
      if @__build_step__ === :update_state_nodes_and_put_context do
        destination_moniker = Helpers.fetch_moniker!(unquote(node_id))
        update_node = &StateNode.put_autotransition(&1, destination_moniker)
        Helpers.update_current_node!(update_node)
      end
    end
  end

  defmacro initial_context(context) do
    quote do
      if @__build_step__ === :update_state_nodes_and_put_context do
        @__context__ unquote(context)
      end
    end
  end

  defmacro event >>> destination_node_id do
    quote bind_quoted: [event: event, node_id: destination_node_id] do
      on(event, do: node_id)
    end
  end

end
