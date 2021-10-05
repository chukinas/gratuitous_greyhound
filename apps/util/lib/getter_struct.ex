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

  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end

  defmacro getter_struct(do: block) do
    quote do
      use TypedStruct
      typedstruct enforce: true do
        plugin unquote Util.GetterStructPlugin
        unquote(block)
      end
    end
  end

end
