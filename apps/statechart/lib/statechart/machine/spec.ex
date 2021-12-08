defmodule Statechart.Machine.Spec do
  @moduledoc """
  Data structure that fully defines a `Statechart` machine.

  It get interpreted by the Statechart.Machine
  """

  alias __MODULE__
  alias Statechart.Type.Context
  alias Statechart.Node.LocalName.Collection, as: LocalNameCollection
  alias Statechart.Node.Collection, as: NodeCollection
  alias Statechart.Node.Moniker

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

  # TODO I finally have a good name for a node's atom name!: node_symbol. Use this everywhere!
  def fetch_node!(%__MODULE__{} = spec, node_symbol) when is_atom(node_symbol) do
    spec
    |> local_names
    |> LocalNameCollection.fetch_moniker!(node_symbol)
    |> then(&fetch_node!(spec, &1))
  end

  def fetch_node!(%__MODULE__{} = spec, %Moniker{} = moniker) do
    spec
    |> nodes
    |> NodeCollection.fetch_node!(moniker)
  end

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
