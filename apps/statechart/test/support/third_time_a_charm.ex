defmodule Statechart.TestSupport.ThirdTimeACharm do

  # Context
  defmodule Platitude do
    use TypedStruct
    typedstruct do
      field(:count, pos_integer, default: 0)
    end
    def new, do: %__MODULE__{}
    def add(%__MODULE__{} = platitude, value) do
      Map.update!(platitude, :count, &(&1 + value))
    end
    def count(%__MODULE__{count: value}), do: value
  end

  # Event
  defmodule HitTheButton do
    use Statechart, :event
    typedstruct do
      field :placeholder, any
    end
    def new, do: %__MODULE__{}
    @impl true
    def action(_, platitude) do
      platitude = Platitude.add(platitude, 1)
      {:ok, platitude}
    end
    @impl true
    def post_guard(_, platitude) do
      case Platitude.count(platitude) do
        count when count >= 3 -> :ok
        _ -> :stay
      end
    end
  end

  # Machine
  defmodule PlatitudeMachine do
    use Statechart, :machine
    initial_context Platitude.new()
    default_state :not_yet
    state :not_yet do
      on HitTheButton, do: :yaayy
    end
    state :yaayy do
      # TODO what's a better way of declaring that I want to stay on this stay
      # (while taking the event's action)?
      on HitTheButton, do: :yaayy
    end
  end


end
