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

  def check_valid(%StateNode{type: {:parent, nil}} = node) do
    {:error, "#{inspect node} is a parent with no default!"}
  end
  def check_valid(_), do: :ok

end
