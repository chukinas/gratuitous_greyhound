defprotocol Statechart.Event.Protocol do

  alias Statechart.Type.Context

  # TODO DRY the return type
  @spec guard(t, Context.t) :: :ok | {:error, reason :: String.t}
  def guard(event, context)

  @spec action(t, Context.t) :: {:ok, Context.t}
  def action(event, context)

  @doc """
  After applying `action` (if we even got that far),
  check this condition. If :ok, procede with transition.
  If :stay, stay on current state node.
  """
  @spec post_guard(t, Context.t) :: :ok | :stay
  def post_guard(event, context)

end

defimpl Statechart.Event.Protocol, for: Atom do
  def guard(_, _), do: :ok
  def action(_, context), do: {:ok, context}
  def post_guard(_, _), do: :ok
end
