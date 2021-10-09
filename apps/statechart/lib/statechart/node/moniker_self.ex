defmodule Statechart.Node.Moniker.Self do
  @type t :: %__MODULE__{}
  defstruct []
  def new, do: %__MODULE__{}
end

defimpl Inspect, for: Statechart.Node.Moniker.Self do
  #import Inspect.Algebra
  require IOP
  def inspect(_, opts) do
    IOP.color("#SelfMoniker")
  end
end
