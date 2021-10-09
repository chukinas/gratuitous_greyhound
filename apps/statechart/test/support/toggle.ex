defmodule Statechart.TestSupport.Toggle do

  defmodule Machine do
    use Statechart, :machine
    defmachine do
      on(:off, do: :off)
      default_to :off
      defstate :off do
        on(:flip, do: :on)
      end
      defstate :on do
        on(:flip, do: :off)
      end
    end
  end

end
