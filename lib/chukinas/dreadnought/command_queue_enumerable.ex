alias Chukinas.Dreadnought.{CommandQueue, Command}

defimpl Enumerable, for: CommandQueue do

  def count(_command_queue), do: {:error, __MODULE__}

  def member?(_command_queue, _element), do: {:ok, false}

  def reduce(_cq, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(cq, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(cq, &1, fun)}
  def reduce(cq, {:cont, acc}, fun) do
    segment_number = cq.segment_counter
    incremented_cq = Map.update!(cq, :segment_counter, &(&1 + 1))
    command = cq.default_command |> Command.set_segment_number(segment_number)
    reduce(incremented_cq, fun.(command, acc), fun)
  end

  def slice(_cq), do: {:error, __MODULE__}
end
