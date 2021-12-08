# TODO is this used anywhere?
defmodule Statechart.Node.LocalName.External do
  defstruct []
  def new, do: %__MODULE__{}
end

defimpl Inspect, for: Statechart.Node.LocalName.External do
  require IOP
  def inspect(_, opts) do
    IOP.color("#External")
  end
end
