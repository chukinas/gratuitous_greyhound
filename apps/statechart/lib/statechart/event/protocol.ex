defprotocol Statechart.Event.Protocol do

  alias Statechart.Type.Context

  # *** *******************************
  # *** TYPES

  @type ok_or_reason :: :ok | {:error, reason :: String.t}

  # *** *******************************
  # *** CALLBACKS

  @spec guard(t, Context.t) :: ok_or_reason
  def guard(event, context)

  @spec action(t, Context.t) :: Context.t
  def action(event, context)

  @spec has_post_guard?(t) :: boolean
  def has_post_guard?(event)

  @spec post_guard(t, Context.t) :: ok_or_reason
  def post_guard(event, context)

end

defimpl Statechart.Event.Protocol, for: Atom do
  def guard(_, _), do: :ok
  def action(_, context), do: context
  def has_post_guard?(_), do: false
  def post_guard(_, _), do: :ok
end
