alias SunsCore.Mission.Subcontext

defprotocol Subcontext do
  @moduledoc """
  Various game phases and steps need to track their own context.

  For example, the Passive Attacks Step needs to track player order.
  A phase or step will initialize a subcontext and then clean up after itself
  when complete.
  """

  @fallback_to_any true

  @spec same_type?(t, module | t) :: boolean
  def same_type?(subcontext1, module_or_struct)

  @spec impl?(t)  :: boolean
  def impl?(maybe_subcontext)
end

defimpl Subcontext, for: Any do

  def __deriving__(module, _struct, _opts) do
    quote do
      defimpl Subcontext, for: unquote(module) do
        def same_type?(subcontext, module)
            when is_atom(module)
            and is_struct(subcontext, module) do
          true
        end
        def same_type?(subcontext, %{__struct__: module}) do
          same_type?(subcontext, module)
        end
        def same_type?(_subcontext, _module_or_struct), do: false

        def impl?(_), do: true
      end
    end
  end

  def same_type?(_, _), do: false
  def impl?(_), do: false
end
