defmodule Statechart.Type.Root do
  defstruct []
  def new, do: %__MODULE__{}
end

defimpl Inspect, for: Statechart.Type.Root do
  #import Inspect.Algebra
  require IOP
  def inspect(_, opts) do
    IOP.color("#Root")
  end
end
