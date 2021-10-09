defmodule Statechart.TestSupport.Baseball do

  # Context
  defmodule StrikeCount do
    @type t :: integer
    def new, do: 0
    def incr(count) when is_integer(count), do: count + 1
  end

  # Event
  defmodule ThrowStrike do
    use Statechart, :event
    defstruct []
    def new, do: %__MODULE__{}
    def action(_, strike_count), do: StrikeCount.incr(strike_count)
    def post_guard(_, strike_count) do
      cond do
        strike_count >= 3 -> :ok
        true -> {:error, "Batter is still in the game!"}
      end
    end
  end

  # Machine
  defmodule Batting do
    use Statechart, :machine
    defmachine do
      initial_context StrikeCount.new()
      default_to :at_bat
      defstate :at_bat do
        on ThrowStrike, do: :struck_out
      end
      defstate :struck_out do
      end
    end
  end


end
