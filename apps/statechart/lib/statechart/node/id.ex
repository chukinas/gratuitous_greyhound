# TODO this should be called Statechart.Node.Id
# I thought previously that I'd call it `Symbol`, but that implies *only* an atom.
defmodule Statechart.Node.Id do
  @moduledoc false

  alias Statechart.Node.Id.Root

  @type t :: atom | Root.t

  # TODO use this where needed
  defguard is_node_id(value) when is_atom(value) or is_struct(value, Root)

end
