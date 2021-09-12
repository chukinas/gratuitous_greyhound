defmodule Statechart.Event do

  alias Statechart.Event.Protocol, as: EventProtocol
  @type std_response :: :ok | {:error, reason :: String.t}
  @callback guard(EventProtocol.t, Context.t) :: std_response
  # TODO is this correct?
  @callback action(EventProtocol.t, Context.t) :: Context.t
  @callback post_guard(EventProtocol.t, Context.t) :: :ok | :stay

  defmacro __using__(_opts) do
    quote do

      use TypedStruct
      alias unquote(__MODULE__)
      @behaviour unquote(__MODULE__)
      alias __MODULE__, as: ThisEvent

      @impl unquote(__MODULE__)
      def guard(_, _), do: :ok

      @impl unquote(__MODULE__)
      def action(_, context), do: {:ok, context}

      @impl unquote(__MODULE__)
      def post_guard(_, context), do: :ok

      defoverridable unquote(__MODULE__)

      defimpl EventProtocol do
        # TODO rename pre_guard
        defdelegate guard(event, context), to: ThisEvent
        defdelegate action(event, context), to: ThisEvent
        defdelegate post_guard(event, context), to: ThisEvent
      end

      def ok, do: :ok
      def ok(response), do: {:ok, response}
      def error(msg), do: {:error, msg}

    end
  end

end
