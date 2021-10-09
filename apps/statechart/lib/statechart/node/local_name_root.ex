defmodule Statechart.Node.LocalName.Root do
  @type t :: %__MODULE__{}
  defstruct []
  def new, do: %__MODULE__{}
end

alias Statechart.Node.LocalName.Root

defimpl Inspect, for: Root do
  #import Inspect.Algebra
  require IOP
  def inspect(_, opts) do
    IOP.color("#Root")
  end
end
