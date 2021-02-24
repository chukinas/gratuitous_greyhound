alias Chukinas.Dreadnought.{CommandQueue}

defimpl Enumerable, for: CommandQueue do

  def count(_command_queue), do: {:error, __MODULE__}

  def member?(_command_queue, _element), do: {:ok, false}

  def reduce(_cq, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(cq, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(cq, &1, fun)}
  def reduce(%CommandQueue{} = cq, {:cont, acc}, fun) do
    seg_num = 1
    # TODO need a default command builder instead of just a default command
    enumerable = {cq.issued_commands, cq.default_command_builder, seg_num}
    reduce(enumerable, {:cont, acc}, fun)
  end
  def reduce({[], default, seg_num}, {:cont, acc}, fun) do
    cmd = default.(seg_num)
    next_seg_num = seg_num + 1
    enumerable = {[], default, next_seg_num}
    reduce(enumerable, fun.(cmd, acc), fun)
  end
  def reduce({[head | tail] = issued, default, seg_num}, {:cont, acc}, fun) do
    {cmd, issued} = case head.segment_number do
      ^seg_num -> {head, tail}
      _ -> {default.(seg_num), issued}
    end
    next_seg_num = seg_num + cmd.segment_count
    enumerable = {issued, default, next_seg_num}
    reduce(enumerable, fun.(cmd, acc), fun)
  end

  def slice(_cq), do: {:error, __MODULE__}
end
