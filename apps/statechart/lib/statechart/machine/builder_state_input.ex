defmodule Statechart.Machine.Builder.StateInput do
  @moduledoc """
  These are the two types of inputs allowed by the Statechart API
  """

  @type t :: atom | [atom]

  defguard is_state_input(val) when is_atom(val) or is_list(val)

end
