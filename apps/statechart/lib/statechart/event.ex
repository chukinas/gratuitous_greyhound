defmodule Statechart.Event do

  alias Statechart.Event.Protocol, as: EventProtocol
  alias Statechart.Type.Context

  # *** *******************************
  # *** TYPES

  @type t :: EventProtocol.t

  @callback guard(EventProtocol.t, Context.t) :: EventProtocol.ok_or_reason
  @callback action(EventProtocol.t, Context.t) :: Context.t
  @callback post_guard(EventProtocol.t, Context.t) :: EventProtocol.ok_or_reason
  @optional_callbacks post_guard: 2

  defmacro __using__(_opts) do
    quote do

      alias unquote(__MODULE__), as: Event

      use TypedStruct
      @behaviour Event

      @impl Event
      def guard(_, _), do: :ok

      @impl Event
      def action(_, context), do: context

      defoverridable Event

      alias __MODULE__, as: EventImpl
      def has_post_guard? do
        EventImpl.__info__(:functions) |> Keyword.has_key?(:post_guard)
      end

      defimpl EventProtocol do
        defdelegate guard(event, context), to: EventImpl
        defdelegate action(event, context), to: EventImpl
        def has_post_guard?(_event), do: EventImpl.has_post_guard?()
        def post_guard(event, context) do
          if EventImpl.has_post_guard?() do
            # Is there a better way to do this?
            # I could also call the function directly, but then non-implementers
            # cause dialyzer warnings
            apply(EventImpl, :post_guard, [event, context])
          else
            :ok
          end
        end
      end

    end
  end

  def to_atom(%{__struct__: module}), do: module
  def to_atom(event) when is_atom(event), do: event

end
