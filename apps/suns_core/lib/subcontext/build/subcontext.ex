defmodule SunsCore.Subcontext.Build do
  @moduledoc """
  `use` this module to register a subcontext that integrates with `Context`.

  In the `Context` typedstruct, add `plugin Subcontext`.
  """

  @callback from_ctx(Context.t()) :: subcontext :: term

  #####################################
  # Plugin for the Context TypedStruct
  #####################################

  use TypedStruct.Plugin

  def field_name, do: :__subcontexts__

  @impl TypedStruct.Plugin
  def field(_, _, _), do: nil

  @impl TypedStruct.Plugin
  defmacro init(_opts) do
    quote do
      field(unquote(__MODULE__).field_name(), %{module => subcontext :: term}, default: %{})
    end
  end

  #####################################
  # For the Subcontext
  #####################################

  defmacro __using__(opts) do
    quote do
      use Subcontext.Build.Context, unquote(opts)
    end
  end
end
