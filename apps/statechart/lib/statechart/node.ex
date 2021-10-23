defmodule Statechart.Node do

  alias Statechart.Node.Moniker
  alias Statechart.Node.Protocol, as: NodeProtocol
  alias Statechart.Node.State, as: StateNode

  # *** *******************************
  # *** TYPES

  @type t :: NodeProtocol.t

  # *** *******************************
  # *** CONVERTERS

  def moniker(node), do: NodeProtocol.moniker(node)

  def name_tuple(node), do: {moniker(node), node}

  @spec next_default!(NodeProtocol.t) :: Moniker.t | Moniker.Self.t
  defdelegate next_default!(node), to: NodeProtocol

  def get_autotransition(%StateNode{autotransition: %Moniker{} = node_name}) do
    node_name
  end
  def get_autotransition(_), do: nil

  defdelegate enter_actions(node), to: NodeProtocol

  defdelegate exit_actions(node), to: NodeProtocol

  def check_valid(%StateNode{type: {:parent, nil}}) do
    {:error, "Parent needs a default!"}
  end
  def check_valid(_), do: :ok

  def compare(node1, node2) do
    Moniker.compare(moniker(node1), moniker(node2))
  end

  def local_name_as_atom(node) do
    node
    |> moniker
    |> Moniker.local_name_as_atom
  end

  def ancestors_as_atom_list(node) do
    node
    |> moniker
    |> Moniker.ancestors_as_atom_list
  end

end
