defmodule Statechart.Node.Id.External do
  @moduledoc """
  A child of `Statechart.Node.Id.Root.t`. Represents nodes outside the scope of a partial machine

  Used when defining partial machines.
  When that partial machine is injected into a parent machine,
  these external ids will be re-mapped to nodes belonging to the parent.
  """

  defstruct []
  def new, do: %__MODULE__{}
end

defimpl Inspect, for: Statechart.Node.Id.External do
  require IOP
  def inspect(_, opts) do
    IOP.color("#External")
  end
end
