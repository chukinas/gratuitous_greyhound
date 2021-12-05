defmodule Util.GetterStructPlugin do

  use TypedStruct.Plugin

  #@impl true
  #defmacro init(_) do
  #  quote do
  #    Module.register_attribute(__MODULE__, :__getter_fields__, accumulate: true)
  #  end
  #end

  @impl true
  def field(name, _type, _opts) do
    quote do
      def unquote(name)(%{unquote(name) => value}) do
        value
      end
      @__getter_fields__ unquote name
    end
  end

  #@impl true
  #def after_definition(_opts) do
  #  quote do
  #    #for field <- @__getter_fields__ do
  #    #  def unquote(var!(field))() do
  #    #    12
  #    #  end
  #    #end
  #    Module.delete_attribute(__MODULE__, :__getter_fields__)
  #  end
  #end

end

defmodule Util.GetterStruct do
  @moduledoc """
  Expose the `getter_struct/2` macro.
  """

  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end

  @doc """
  Example:
  ```elixir
  defmodule MyModule do
    use Util.GetterStruct
    getter_struct do
      field :hello, String.t
      field :world, String.t, enforce: false
    end
  end
  ```

  Translates to:
  ```elixir
  defmodule MyModule do
    use TypedStruct
    typedstruct, enforce: true do
      field :hello, String.t
      field :world, String.t, enforce: false
    end

    def hello(%__MODULE__{hello: value}), do: value
    def world(%__MODULE__{world: value}), do: value
  end
  ```
  """
  defmacro getter_struct(opts \\ [], do: block) do
    quote do
      use TypedStruct
      typedstruct Keyword.put_new(unquote(opts), :enforce, true) do
        # TODO is this unquote necessary?
        plugin unquote(Util.GetterStructPlugin)
        unquote(block)
      end
    end
  end

end
