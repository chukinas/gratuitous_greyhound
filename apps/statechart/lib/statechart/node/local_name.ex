defmodule Statechart.Node.LocalName do
  @moduledoc """
  The innermost Moniker element

  Unique local node names can be used to uniquely identify Nodes.
  """
  alias Statechart.Node.LocalName.Root
  @type t :: atom | Root.t
end
