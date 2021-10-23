defmodule Statechart.TestSupport.Counter do

  alias Statechart.Node.Moniker

  defmodule Context do
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

  defmodule Increment do
    use Statechart, :event
    defstruct []
    def new, do: %__MODULE__{}
    @impl true
    def action(%__MODULE__{}, counter), do: Context.add(counter, 1)
  end

  defmodule Decrement do
    use Statechart, :event
    defstruct []
    def new, do: %__MODULE__{}
    @impl true
    def guard(_, counter) do
      if Context.count(counter) > 0 do
        :ok
      else
        {:error, "Context cannot be decremented when at zero"}
      end
    end
    @impl true
    def action(%__MODULE__{}, counter), do: Context.add(counter, -1)
  end

  defmodule Machine do
    use Statechart, :machine
    defmachine do
      initial_context Context.new()
      on(Increment, do: Moniker.new_root())
      on(Decrement, do: Moniker.new_root())
    end
  end

  def incr(%Statechart.Machine{} = machine) do
    Statechart.transition(
      machine,
      Increment.new()
    )
  end

  def decr(%Statechart.Machine{} = machine) do
    Statechart.transition(
      machine,
      Decrement.new()
    )
  end

end
