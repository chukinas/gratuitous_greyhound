defmodule Statechart.Machine.Spec do
  @moduledoc """
  Data structure that fully defines a `Statechart` machine.

  It get interpreted by the Statechart.Machine
  """

  alias __MODULE__
  alias Statechart.Type.Context
  alias Statechart.Node.LocalName.Collection, as: LocalNameCollection
  alias Statechart.Node.Collection, as: NodeCollection

  # *** *******************************
  # *** TYPES

  @type getter :: (-> t)

  use Util.GetterStruct
  getter_struct do
    field :_module, module
    field :local_names, LocalNameCollection.t, default: LocalNameCollection.empty()
    field :context, Context.t
    field :nodes, NodeCollection.t, default: NodeCollection.new()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(module, context, local_names, nodes) do
    %__MODULE__{
      _module: module,
      context: context,
      local_names: local_names,
      nodes: nodes
    }
  end

  # *** *******************************
  # *** CONVERTERS

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Statechart.Render.Protocol do
    def render(spec, statemachine) do
      spec
      |> Spec.nodes
      |> Statechart.Render.Protocol.render(statemachine)
    end
  end

end
