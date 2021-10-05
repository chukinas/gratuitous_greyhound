defmodule Statechart.CounterTest do

  alias Statechart.Type.NodeName

  defmodule Counter do
    use TypedStruct
    typedstruct do
      field(:count, pos_integer, default: 0)
    end
    def new, do: %__MODULE__{}
    def add(%__MODULE__{} = counter, value) do
      Map.update!(counter, :count, &(&1 + value))
    end
    def count(%__MODULE__{count: value}), do: value
  end

  defmodule CounterIncrement do
    use Statechart, :event
    typedstruct do
      field(:value, integer, default: 1)
    end
    def new, do: %__MODULE__{}
    @impl true
    def action(%__MODULE__{value: value}, counter) do
      counter = Counter.add(counter, value)
      {:ok, counter}
    end
  end

  defmodule CounterDecrement do
    use Statechart, :event
    typedstruct do
      field(:value, integer, default: -1)
    end
    def new, do: %__MODULE__{}
    @impl true
    def guard(_, counter) do
      if Counter.count(counter) > 0 do
        :ok
      else
        {:error, "Counter cannot be decremented when at zero"}
      end
    end
    @impl true
    def action(%__MODULE__{value: value}, counter) do
      counter = Counter.add(counter, value)
      {:ok, counter}
    end
  end

  defmodule CounterMachine do
    use Statechart, :machine
    initial_context Counter.new()
    on(CounterIncrement, do: NodeName.root())
    on(CounterDecrement, do: NodeName.root())
  end


end
