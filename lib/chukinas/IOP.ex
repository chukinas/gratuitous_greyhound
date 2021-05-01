defmodule IOP do

  @opts [
    syntax_colors: [
      number: :light_yellow,
      atom: :cyan,
      string: :yellow,
      boolean: :red,
      binary: :yellow,
      tuple: :yellow,
      map: [:light_cyan, :bright],
      nil: [:magenta, :bright]
    ]
  ]

  def inspect(term, label, opts \\ []) do
    show_if = Keyword.get(opts, :show_if, fn _x -> true end)
    if show_if.(term) do
      filtered_term = case Keyword.get(opts, :keys, nil) do
        nil -> term
        keys -> Map.take(term, keys)
      end
      IO.inspect(filtered_term, Keyword.merge(@opts, label: label))
    end
    term
  end

  def inspect(term) do
    IO.inspect(term, @opts)
  end
end
