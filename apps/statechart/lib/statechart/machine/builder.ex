defmodule Statechart.Machine.Builder do
  @moduledoc """
  A behavior that ensures a modules has a function for returning a Machine
  """

  alias Statechart.Machine
  alias Statechart.Machine.Accumulator
  alias Statechart.Machine.Spec

  # TODO remove get_def
  @callback get_def() :: Spec.t
  @callback new() :: Machine.t

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      require unquote(__MODULE__)
      import unquote(__MODULE__)
      @__acc__ Accumulator.new()
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @__machine__ Spec.from_accumulator(@__acc__)
      @impl unquote(__MODULE__)
      @spec get_def :: Spec.t
      def get_def, do: @__machine__
      @impl unquote(__MODULE__)
      @spec new :: Machine.t
      def new do
        Machine.from_spec(__MODULE__)
      end
      defdelegate transition(machine, event), to: Machine
      Module.delete_attribute(__MODULE__, :__acc__)
      Module.delete_attribute(__MODULE__, :__machine__)
    end
  end

  defmacro state(name, do: block) do
    quote do
      @__acc__ Accumulator.add_depth_to_current_state(@__acc__, unquote(name))
      unquote(block)
      @__acc__ Accumulator.remove_depth_from_current_state(@__acc__)
    end
  end

  defmacro default_state(default_node_name) do
    quote do
      @__acc__ Accumulator.add_default(@__acc__, unquote(default_node_name))
    end
  end

  defmacro initial_context(context) do
    quote do
      @__acc__ Accumulator.set_init_context(@__acc__, unquote(context))
    end
  end

  defmacro on(event, do: next_state) do
    quote do
      @__acc__ Accumulator.add_transition(@__acc__, unquote(event), unquote(next_state))
    end
  end

  defmacro on_enter(fun) do
    quote do
      @__acc__ Accumulator.on_enter(@__acc__, unquote(fun))
    end
  end

  defmacro autotransition(node_name) do
    quote do
      @__acc__ Accumulator.autotransition(@__acc__, unquote(node_name))
    end
  end

end
