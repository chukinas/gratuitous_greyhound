defmodule Statechart.Node.LocalName.Root do
  @moduledoc false

  use TypedStruct
  typedstruct do
  end

  def new, do: %__MODULE__{}
  def name_as_atom(%__MODULE__{}), do: :root
end

defimpl Inspect, for: Statechart.Node.LocalName.Root do
  require IOP
  def inspect(%{}, opts) do
    IOP.color("#Root")
  end
end
