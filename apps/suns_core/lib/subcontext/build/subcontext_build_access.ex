defmodule SunsCore.Subcontext.Build.Access do
  alias SunsCore.Context

  @field_name SunsCore.Subcontext.Build.field_name()

  defp fetch_subcontexts!(%Context{unquote(@field_name) => subcontexts}) do
    subcontexts
  end

  def fetch(%Context{} = ctx, subctx_key) do
    ctx
    |> fetch_subcontexts!
    |> Map.fetch(subctx_key)
  end

  def fetch!(%Context{} = ctx, subctx_key) do
    case fetch(ctx, subctx_key) do
      {:ok, subcontext} -> subcontext
      :error -> raise "No #{subctx_key} found in context!"
    end
  end

  def get(%Context{} = ctx, subctx_key) do
    case fetch(ctx, subctx_key) do
      {:ok, subcontext} -> subcontext
      :error -> subctx_key.from_ctx(ctx)
    end
  end

  def put(%Context{} = ctx, subctx_key, subcontext) do
    subcontexts =
      ctx
      |> fetch_subcontexts!
      |> Map.put(subctx_key, subcontext)

    %{ctx | @field_name => subcontexts}
  end

  def update!(%Context{} = ctx, subctx_key, fun) do
    subcontext = ctx |> fetch!(subctx_key) |> fun.()
    put(ctx, subctx_key, subcontext)
  end

  def drop(%Context{} = ctx, subctx_key) do
    Map.update!(ctx, @field_name, &Map.drop(&1, [subctx_key]))
  end

  def init(%Context{} = ctx, subctx_key) do
    case fetch(ctx, subctx_key) do
      {:ok, _subcontext} ->
        raise "subcontext #{subctx_key} already exists!"

      :error ->
        subcontext = subctx_key.from_ctx(ctx)
        put(ctx, subctx_key, subcontext)
    end
  end
end
