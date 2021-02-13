alias Chukinas.Dreadnought.{CommandQueue}

defimpl Enumerable, for: CommandQueue do

  def count(_command_queue), do: {:error, __MODULE__}

  # TODO this needs to be implemented
  def member?(_command_queue, _element), do: {:ok, false}

  def reduce(_cq, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(cq, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(cq, &1, fun)}
  def reduce(cq, {:cont, acc}, fun), do: reduce(cq, fun.(cq.default_command, acc), fun)

  def slice(_cq), do: {:error, __MODULE__}
end
