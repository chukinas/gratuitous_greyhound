defmodule SunsCore.Event do

  defmacro __using__(:placeholders) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end

  defmacro __using__(:impl) do
    quote do
      use Statechart, :event
      alias SunsCore.Context, as: S
      alias SunsCore.Context, as: Cxt
      import unquote(__MODULE__), only: [event_struct: 1]
    end
  end

  defmacro event_struct(do: block) do
    quote do
      typedstruct enforce: true do
        field :initiator, integer() | :system, default: :system
        unquote(block)
      end
    end
  end

  defmacro placeholder_event(module) do
    quote do
      defmodule unquote(module) do
        use SunsCore.Event, :impl
        event_struct do
          field :placeholder, any
        end
      end
    end
  end

end
