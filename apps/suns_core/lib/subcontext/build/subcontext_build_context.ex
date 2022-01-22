defmodule Subcontext.Build.Context do
  import Kernel, except: [def: 2]

  @doc """
  `use` in `Some.Subcontext.Module` to generate a `Some.Context.Module`.
  """
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__), only: [def: 2]
      Module.register_attribute(__MODULE__, :subctx_fun_heads, accumulate: true)
      @before_compile {unquote(__MODULE__), :__build_context_module__}
      @behaviour Subcontext
    end
  end

  @doc false
  defmacro def(fn_head, do: block) do
    quote do
      if Module.has_attribute?(__MODULE__, :context) do
        @subctx_fun_heads unquote(Macro.escape(fn_head))
        Module.delete_attribute(__MODULE__, :context)
      end

      Kernel.def(unquote(fn_head), do: unquote(block))
    end
  end

  Kernel.def __build_context_module__(env) do
    fn_heads = Module.get_attribute(env.module, :subctx_fun_heads)

    Module.create(
      context_from_subcontext(env.module),
      quoted_context_module(env.module, fn_heads),
      Macro.Env.location(env)
    )
  end

  defp context_from_subcontext(module) when is_atom(module) do
    module
    |> Module.split()
    |> Enum.reverse()
    |> case do
      [module_alias, "Subcontext" | tail] ->
        [module_alias, "Context" | tail]
        |> Enum.reverse()
        |> Module.concat()

      _ ->
        raise "Module must follow the pattern `OneOrMoreParentNamespaces.Subcontext.Name`, got: #{inspect(module)}"
    end
  end

  defp quoted_context_module(subcontext_module, subctx_fn_heads) do
    alias Subcontext.Build.Access, as: SubctxAccess

    standard_fns_block =
      quote do
        @subcontext unquote(subcontext_module)
        def get(%Context{} = ctx), do: SubctxAccess.get(ctx, @subcontext)
        def init(%Context{} = ctx), do: SubctxAccess.init(ctx, @subcontext)
        def drop(%Context{} = ctx), do: SubctxAccess.drop(ctx, @subcontext)
        def fetch(%Context{} = ctx), do: SubctxAccess.fetch(ctx, @subcontext)
        def fetch!(%Context{} = ctx), do: SubctxAccess.fetch!(ctx, @subcontext)
        def put(%Context{} = ctx, subcontext), do: SubctxAccess.put(ctx, @subcontext, subcontext)
        def update!(%Context{} = ctx, fun), do: SubctxAccess.update!(ctx, @subcontext, fun)
      end

    custom_fns_block =
      for fn_head <- subctx_fn_heads do
        build_ctx_fn(subcontext_module, fn_head)
      end

    quote do
      unquote(standard_fns_block)
      unquote_splicing(custom_fns_block)
    end
  end

  defp build_ctx_fn(module, fn_head) do
    {fn_name, _meta, args} = fn_head
    fn_args = Macro.generate_arguments(length(args) - 1, module)

    quote do
      def unquote(fn_name)(%Context{} = context, unquote_splicing(fn_args)) do
        subcontext =
          context
          |> get
          |> @subcontext.unquote(fn_name)(unquote_splicing(fn_args))

        put(context, subcontext)
      end
    end
  end
end
