defmodule Statechart.TestSupport.Decision do

  alias __MODULE__

  def ready?(%{ready?: val} = _context), do: val

  defmodule Machine do
    use Statechart, :machine
    defmachine do
      initial_context %{ready?: true}
      default_to :if_ready
      decision :if_ready,
        &Decision.ready?/1,
        if_true: :starting,
        else: :stopping
      defstate :starting
      defstate :stopping
    end
  end

end
